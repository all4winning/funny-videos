class Add < ActiveRecord::Migration
  def up
    add_column :posts, :video_url, :string
    add_column :posts, :video_id,  :string
    remove_column :posts, :image_url
  end

  def down
    remove_column :posts, :video_url
    remove_column :posts, :video_id
    add_column :posts, :image_url,  :string
  end
end
