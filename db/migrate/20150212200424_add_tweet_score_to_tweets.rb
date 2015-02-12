class AddTweetScoreToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :tweetScore, :integer
  end
end
