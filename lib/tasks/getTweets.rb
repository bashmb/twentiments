# get most recent 10 tweets
friend = "mikebashour"
tweets = CLIENT.user_timeline(friend)
(10).downto(0).each do |i|
	newTweet = Tweet.new
	newTweet.tweetTime = tweets[i].created_at.to_i
	lastTweetTime = Tweet.where(twitterHandle:friend).maximum("tweetTime")
	if lastTweetTime == nil or newTweet.tweetTime > lastTweetTime
		newTweet.twitterHandle = friend
		newTweet.tweetText = tweets[i].text.chomp
		newTweet.tweetScore = (Indico.sentiment(newTweet.tweetText)*100).round
		newTweet.save
	end
end