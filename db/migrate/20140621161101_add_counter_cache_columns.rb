class AddCounterCacheColumns < ActiveRecord::Migration
  def up
    add_column :posts, :post_views_count, :integer
    add_column :users, :post_views_count, :integer
    add_column :users, :posts_count, :integer
  end

  def down
    remove_column :posts, :post_views_count
    remove_column :users, :post_views_count
    remove_column :users, :posts_count
  end
end
