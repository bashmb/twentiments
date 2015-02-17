class AddImgToFriend < ActiveRecord::Migration
  def change
  	add_column :friends, :friendImgURL, :string
  end
end
