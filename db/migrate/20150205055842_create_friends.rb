class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :firstName
      t.string :twitterHandle

      t.timestamps null: false
    end
  end
end
