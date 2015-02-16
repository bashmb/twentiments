desc "Get updated user info"
task :getUserInfo => :environment do
	Friend.all.each do |handle|
		# find the id
		friendID = Friend.where(twitterHandle:handle.twitterHandle)
		description = CLIENT.user(handle.twitterHandle).description
		Friend.update(friendID, :friendDescription => description)
	end
end