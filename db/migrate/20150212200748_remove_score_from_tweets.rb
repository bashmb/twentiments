class RemoveScoreFromTweets < ActiveRecord::Migration
  def change
    remove_column :tweets, :score, :integer
  end
end
