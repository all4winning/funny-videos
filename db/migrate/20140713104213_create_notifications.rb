class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :about_id
      t.string :about_type
      t.string :notification_type

      t.timestamps
    end
  end
end
