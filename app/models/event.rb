class Event < ActiveRecord::Base
	validates :user_id, presence: true
	belongs_to :user
	default_scope -> { order('time DESC') }
end
