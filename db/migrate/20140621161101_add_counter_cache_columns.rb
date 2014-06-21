class AddCounterCacheColumns < ActiveRecord::Migration
  def up
    add_column :posts, :post_views_count, :integer
    add_column :users, :post_views_count, :integer
    add_column :users, :posts_count, :integer
  end

  def down
  end
end
