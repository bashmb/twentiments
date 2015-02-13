require 'open-uri'
class FriendsController < ApplicationController
	def create
		@friend = Friend.new(friend_params)
		@friend['twitterHandle'] = @friend['twitterHandle'].gsub(/@/,"")
		begin
			if CLIENT.user(@friend.twitterHandle).created?
				@friend['firstName'] = CLIENT.user(@friend.twitterHandle).name
				@friend.save
					tweets = CLIENT.user_timeline(@friend.twitterHandle)
					(10).downto(0).each do |i|
						newTweet = Tweet.new
						newTweet.tweetTime = tweets[i].created_at.to_i
						lastTweetTime = Tweet.where(twitterHandle:@friend.twitterHandle).maximum("tweetTime")
						if lastTweetTime == nil or newTweet.tweetTime > lastTweetTime
							newTweet.twitterHandle = @friend.twitterHandle
							newTweet.tweetText = tweets[i].text.chomp
							newTweet.tweetScore = (Indico.sentiment(newTweet.tweetText)*100).round
							newTweet.save
						end
					end
				redirect_to :friends
			end
		rescue
			redirect_to @friend
		end

	end

	def new
	end

	def index
		@friends = Friend.all
		@scoreColorArray = [	
							"#CC0033", 	#00
							"#CC0033",	#01
							"#CC0033",	#02
							"#B61945",	#03
							"#A13256",	#04
							"#607D8B", 	#05
							"#458E75",	#06
							"#3C936D",	#07
							"#339966",	#08
							"#339966",	#09
							"#339966" ]	#10
	end
	
	def show
		@latestTweets = Tweet.where(twitterHandle:params[:id]).order(Tweet.arel_table[:tweetTime].desc).limit(10)
		@friend = Friend.where(twitterHandle:params[:id])
		@tweets = CLIENT.user_timeline(params[:id])

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
		
		@user1Friend = Friend.where(twitterHandle:params[:user_1])
		@user2Ffriend = Friend.where(twitterHandle:params[:user_2])
		
		@user1tweets = CLIENT.user_timeline(params[:user_1])
		@user2tweets = CLIENT.user_timeline(params[:user_2])
	end

	private
		def friend_params
			params.require(:friend).permit(:twitterHandle)
		end

end
