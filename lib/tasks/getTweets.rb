require "twitter"
# get most recent 10 tweets
friend = "dalailama"
tweets = CLIENT.user_timeline(friend)
(10).downto(0).each do |i|
	newTweet = Tweet.new
	newTweet.twitterHandle = friend
	newTweet.tweetText = tweets[i].text
	newTweet.tweetTime = tweets[i].created_at.to_i
	lastTweetTime = Tweet.where(twitterHandle:friend).maximum("tweetTime")
	if lastTweetTime == nil or newTweet.tweetTime > lastTweetTime
		newTweet.save
	end

end