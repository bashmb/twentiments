# require 'open-uri'
class FriendsController < ApplicationController
	def create
		@friend = Friend.new(friend_params)
		@friend['twitterHandle'] = @friend['twitterHandle'].gsub(/@/,"")
		begin
			clientData = CLIENT.user(@friend.twitterHandle)
			if clientData.created?
				@friend['firstName'] = clientData.name
				@friend['friendImgURL'] = clientData.profile_image_url
				@friend.save

					tweets = CLIENT.user_timeline(@friend.twitterHandle)
					(9).downto(0).each do |i|
						lastTweetTime = Tweet.where(twitterHandle:@friend.twitterHandle).maximum("tweetTime")
						newTweet = Tweet.new
						if tweets[i] == nil
							newTweet.twitterHandle = @friend.twitterHandle
							newTweet.tweetTime = 10000
							newTweet.tweetScore = 50
							newTweet.tweetText = ""
							newTweet.save
						else
							newTweet.twitterHandle = @friend.twitterHandle
							newTweet.tweetTime = tweets[i].created_at.to_i
							newTweet.tweetText = tweets[i].text.chomp
							newTweet.tweetScore = (Indico.sentiment(newTweet.tweetText)*100).round
							newTweet.save
						end
					end

				redirect_to :friend
			end
		rescue
			redirect_to :friends
		end

	end

	def new
	end

	def index
		@friends = Friend.all
		@friendArray = []
		Friend.all.each do |friend|
			@friendArray << friend.twitterHandle
		end

		@scoreColorArray = [	
							"#FF5782", 	#00
							"#FF5782",	#01
							"#FF5782",	#02
							"#FF5782",	#03
							"#607D8B",	#04
							"#607D8B", 	#05
							"#607D8B",	#06
							"#8BC34A",	#07
							"#8BC34A",	#08
							"#8BC34A",	#09
							"#8BC34A" ]	#10
		@dropdownColorArray = [
							"#F57C00", 	#00
							"#F57C00",	#01
							"#F57C00",	#02
							"#F57C00",	#03
							"#CFD8DC",	#04
							"#CFD8DC", 	#05
							"#CFD8DC",	#06
							"#DCEDC8",	#07
							"#DCEDC8",	#08
							"#DCEDC8",	#09
							"#DCEDC8" ]	#10
	end
	
	def show
		@latestTweets = Tweet.where(twitterHandle:params[:id]).order(Tweet.arel_table[:tweetTime].desc).limit(10)
		@friend = Friend.where(twitterHandle:params[:id])
		
	end

	def destroy
		Friend.where(twitterHandle:params[:id]).destroy_all
		Tweet.where(twitterHandle:params[:id]).destroy_all
		redirect_to '/'
	end
	
	def compare
		@user1 = params[:user_1]
		@user2 = params[:user_2]

		@user1LatestTweets = Tweet.where(twitterHandle:params[:user_1]).order(Tweet.arel_table[:tweetTime].desc).limit(10)
		@user2LatestTweets = Tweet.where(twitterHandle:params[:user_2]).order(Tweet.arel_table[:tweetTime].desc).limit(10)
		
		@user1Friend = Friend.where(twitterHandle:params[:user_1]).to_a
		@user2Friend = Friend.where(twitterHandle:params[:user_2]).to_a
		
	end

	private
		def friend_params
			params.require(:friend).permit(:twitterHandle)
		end

end
