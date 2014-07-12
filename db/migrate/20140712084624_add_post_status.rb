class AddPostStatus < ActiveRecord::Migration
  def up
    add_column :posts, :featured, :boolean
    add_column :posts, :state, :string
  end

  def down
    remove_column :posts, :featured
    remove_column :posts, :state
  end
end
