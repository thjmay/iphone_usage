class MixpanelExport

	require 'net/https'
	require 'json'
	require 'digest/md5'
	require 'open-uri'
	require 'uri'


	attr_accessor :event, :where, :from_date, :to_date, :bucket # @where in the from 'properties["property"]==...' etc.

	def perform_query

		if ( @from_date.nil? || @to_date.nil? )

			puts 'Require from_date and to_date.'

		else

			amp_where = nil
			equal_where = nil
			unless @where.nil?
				amp_where = "&where=#{@where}"
				equal_where = "where=#{@where}"
			end

			amp_event = nil
			equal_event = nil
			unless @event.nil?
				amp_event = "&event=#{@event}"
				equal_event = "event=#{@event}"
			end

			api_key = credentials('api_key')
			api_secret = credentials('api_secret')

			d = Time.now.utc
			expire = (d + 10000).to_i.to_s

			args_concat = "api_key=#{api_key}#{equal_event}expire=#{expire}from_date=#{@from_date}to_date=#{@to_date}#{equal_where}"
			sig = Digest::MD5.hexdigest(args_concat + api_secret)

			http = Net::HTTP.new("data.mixpanel.com",443)
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			url = "/api/2.0/export/?api_key=#{api_key}&expire=#{expire}&from_date=#{@from_date}&to_date=#{@to_date}#{amp_where}&sig=#{sig}#{amp_event}"
			http.use_ssl = true
			get = Net::HTTP::Get.new(URI.escape(url))
			req = http.request(get)
			contents = req.body
			data = Array.new
			contents.each_line do |line|
				hash = JSON.parse(line)
				data.push(hash)
			end

			return data

		end

	end

	private

	def credentials(name)

		if name == "api_key"

			return 'cd35be6d84e06994cb8d629d0e8214f6'

		elsif name == "api_secret"

			return '2f2e6ffaef299a5def7fae474476fc27'

		end

	end
end


def get_data_dump(from_date,to_date)
	api = MixpanelExport.new
	api.from_date = from_date
	api.to_date = to_date
	data = api.perform_query
	return data
end

from_date = (Time.new - 86400).strftime("%Y-%m-%d")
to_date = (Time.new - 86400).strftime("%Y-%m-%d")

#Get dump of data and create users hash and events array.
users = Hash.new
events = Array.new
data = get_data_dump(from_date,to_date)
data.each do |hash|
	properties = hash['properties']
	distinct_id = properties['distinct_id'].upcase
	event = hash['event']
	logged_in = properties['logged_in']
	app_version = properties['$app_version']
	sk_user_id = properties['user_id']
	wifi = properties['$wifi']
	time_int = properties['time']
	time = Time.at(time_int)
	if properties.has_key?('SK_event_id')
		sk_event_id = properties['SK_event_id']
	else
		sk_event_id = properties['event_id']
	end
	if properties.has_key?('SK_ticketed_event')
		sk_ticketed_event = properties['SK_ticketed_event']
		if sk_ticketed_event == "true"
			sk_ticketed_event = 1
		elsif sk_ticketed_event == "false"
			sk_ticketed_event = 0
		end
	else
		sk_ticketed_event = properties['SK_ticketed']
		if sk_ticketed_event == true
			sk_ticketed_event = 1
		elsif sk_ticketed_event == false
			sk_ticketed_event = 0
		end
	end
			

	#Update users hash
	if users.has_key?(distinct_id)
		#User in users hash. Update
		user = users[distinct_id]
		if event == 'checkout - view_order_confirmation'
			user[:transactions] += 1
		end
		full_user = user[:full_user]
		if (full_user == 0 && logged_in == "true" )
			user[:full_user] = 1
		elsif (full_user == 1 && logged_in == "false")
			user[:full_user] = 0
		end
		if (user[:sk_user_id].nil? && properties.has_key?('user_id'))
			user[:sk_user_id] = sk_user_id
		end
		user_app_version = user[:app_version]
		if app_version != user_app_version
			user[:app_version] = app_version
		end

	else
		#User not in users hash. Create
		if event == 'checkout - view_order_confirmation'
			transactions = 1
		else
			transactions = 0
		end
		if logged_in == "true"
			full_user = 1
		else
			full_user = 0
		end
		user = Hash.new
		user[:distinct_id] = distinct_id
		user[:transactions] = transactions
		user[:full_user] = full_user
		user[:sk_user_id] = sk_user_id
		user[:app_version] = app_version
		users[distinct_id] = user

	end

	#Update events array
	event_hash = Hash.new
	event_hash[:name] = event
	if wifi == true
		event_hash[:wifi] = 1
	else
		event_hash[:wifi] = 0
	end
	event_hash[:distinct_id] = distinct_id
	event_hash[:time] = time
	event_hash[:sk_event_id] = sk_event_id
	event_hash[:sk_ticketed_event] = sk_ticketed_event
	events.push(event_hash)

end

#Add users to table
users_array = users.values
users_array.each do |user|
	distinct_id = user[:distinct_id]
	db_user = User.find_by(distinct_id: distinct_id)
	if db_user.nil?
		User.create!(user)
	else
		transactions = user[:transactions]
		full_user = user[:full_user]
		sk_user_id = user[:sk_user_id]
		app_version = user[:app_version]
		
		db_user.transactions += transactions
		db_user.full_user = full_user
		unless sk_user_id.nil?
			db_user.sk_user_id = sk_user_id
		end
		db_user.app_version = app_version

		db_user.save!
	end
end

#Associate events with users and create event
events.each do |event|
	distinct_id = event[:distinct_id].upcase
	user = User.find_by(distinct_id: distinct_id)
	event[:user] = user
	Event.create!(event)
end


