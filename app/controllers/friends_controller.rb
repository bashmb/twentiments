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
		
		@user1Friend = Friend.where(twitterHandle:params[:user_1]).to_a
		@user2Friend = Friend.where(twitterHandle:params[:user_2]).to_a
		
		@user1tweets = CLIENT.user_timeline(params[:user_1])
		@user2tweets = CLIENT.user_timeline(params[:user_2])
	end

	private
		def friend_params
			params.require(:friend).permit(:twitterHandle)
		end

end
