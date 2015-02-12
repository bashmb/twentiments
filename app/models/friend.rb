class Friend < ActiveRecord::Base
	has_many :tweets
	validates :firstName, presence: true
	validates :twitterHandle, presence: true
end
