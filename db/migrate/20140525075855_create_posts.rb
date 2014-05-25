class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :image
      t.string :title
      t.text :description
      t.integer :user_id
      t.string :slug, :unique => true
      t.string :type

      t.timestamps
    end
  end
end
