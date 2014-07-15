class AddFieldsToUser < ActiveRecord::Migration
  def up
    add_column :users, :last_seen_notifications, :datetime
    add_column :users, :birthdate, :datetime
    add_column :users, :banned, :boolean
    add_column :users, :gender, :string
    add_column :users, :fb_token, :string
    add_column :users, :fb_token_expires_at, :datetime
  end

  def down
    remove_column :users, :last_seen_notifications
    remove_column :users, :birthdate
    remove_column :users, :banned
    remove_column :users, :gender
    remove_column :users, :fb_token
    remove_column :users, :fb_token_expires_at
  end
end
