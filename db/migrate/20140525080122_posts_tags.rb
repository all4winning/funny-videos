class PostsTags < ActiveRecord::Migration
  def change
    create_table :posts_tags do |t|
      t.integer :tag_id
      t.integer :post_id

      t.timestamps
    end
  end
end
