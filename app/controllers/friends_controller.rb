require 'open-uri'
class FriendsController < ApplicationController
	def create
		@friend = Friend.new(friend_params)
		@friend['twitterHandle'] = @friend['twitterHandle'].gsub(/@/,"")
		friendHash = JSON.load(open("https://twitter.com/users/username_available?username="+@friend['twitterHandle']))
		begin
			if CLIENT.user(@friend.twitterHandle).created?
				@friend['firstName'] = CLIENT.user(@friend.twitterHandle).name
				@friend.save
				redirect_to @friend
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
		@friend = Friend.find(params[:id])
		@tweets = CLIENT.user_timeline(@friend.twitterHandle)
		@score = (Indico.sentiment(@tweets[0].text)*100).round
		@historicalScores = []
		for i in 0..10
			@historicalScores << ((Indico.sentiment@tweets[i].text)*100).round
		end


		colorScore = (@score / 10).round
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
		@scoreColor = @scoreColorArray[((@score / 10).round)]
	end

	def destroy
		Friend.find(params['id']).destroy
		redirect_to :friends
	end
	
	private
		def friend_params
			params.require(:friend).permit(:twitterHandle)
		end

end
