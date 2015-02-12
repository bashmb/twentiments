class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :twitterHandle
      t.text :tweetText
      t.integer :tweetTime

      t.timestamps null: false
    end
  end
end
