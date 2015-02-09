class FriendsController < ApplicationController
	def create
		@friend = Friend.new(friend_params)
		@friend.save
		redirect_to @friend
	end

	def new
	end

	def index
		@friends = Friend.all

	end
	
	def show
		@friend = Friend.find(params[:id])
		@tweets = CLIENT.user_timeline(@friend.twitterHandle)
	end

	def destroy
		Friend.find(params['id']).destroy
		redirect_to :friends
	end
	
	private
		def friend_params
			params.require(:friend).permit(:firstName, :twitterHandle)
		end

end
