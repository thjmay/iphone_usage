class User < ActiveRecord::Base
	has_many :events
	before_save { self.distinct_id = distinct_id.upcase }
	validates :distinct_id, presence: true, uniqueness: {case_sensitive: false}
	validates :sk_user_id, presence: true
	validates :full_user, presence: true
	validates :transactions, presence: true
	validates :app_version, presence: true
end
