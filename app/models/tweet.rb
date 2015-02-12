class Tweet < ActiveRecord::Base
	belongs_to :friend
end
