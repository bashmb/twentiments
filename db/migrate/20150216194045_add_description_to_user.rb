class AddDescriptionToUser < ActiveRecord::Migration
  def change
    add_column :friends, :friendDescription, :text
  end
end
