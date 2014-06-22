class CreatePostViews < ActiveRecord::Migration
  def change
    create_table :post_views do |t|
      t.string :ip
      t.integer :user_id
      t.integer :post_id
      t.integer :nr_views, default: 0

      t.timestamps
    end

    add_index :post_views, [:user_id, :post_id, :ip], unique: true
  end
end
