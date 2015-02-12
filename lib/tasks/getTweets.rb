# get most recent 10 tweets

Friend.all.each do |handle|
	tweets = CLIENT.user_timeline(handle.twitterHandle)
	(10).downto(0).each do |i|
		newTweet = Tweet.new
		newTweet.tweetTime = tweets[i].created_at.to_i
		lastTweetTime = Tweet.where(twitterHandle:handle.twitterHandle).maximum("tweetTime")
		if lastTweetTime == nil or newTweet.tweetTime > lastTweetTime
			newTweet.twitterHandle = handle.twitterHandle
			newTweet.tweetText = tweets[i].text.chomp
			newTweet.tweetScore = (Indico.sentiment(newTweet.tweetText)*100).round
			newTweet.save
		end
	end
end