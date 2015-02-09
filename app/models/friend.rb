class Friend < ActiveRecord::Base
	validates :firstName, presence: true
	validates :twitterHandle, presence: true
end
