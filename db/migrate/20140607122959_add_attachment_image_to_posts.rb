class AddAttachmentImageToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.attachment :image
    end
    rename_column :posts, :image, :image_url
  end

  def self.down
    drop_attached_file :posts, :image
  end
end
