class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :post_id
      t.datetime :created_at

      t.timestamps
    end
  end
end
