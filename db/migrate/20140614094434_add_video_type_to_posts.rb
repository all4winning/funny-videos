class AddVideoTypeToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :video_type, :string
    add_column :posts, :video_embed_url, :string
  end

  def down
    remove_column :posts, :video_type
    remove_column :posts, :video_embed_url
  end
end
