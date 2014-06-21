class CreateNotificationSettings < ActiveRecord::Migration
  def change
    create_table :notification_settings do |t|
      t.integer :user_id
      t.string :notification_type
      t.boolean :email_enabled, default: true
      t.boolean :facebook_enabled, default: true
      t.boolean :notification_enabled, default: true
      t.boolean :editable, default: false

      t.timestamps
    end

    add_index :notification_settings, [:user_id, :notification_type], unique: true
    add_index :notification_settings, :editable
  end
end
