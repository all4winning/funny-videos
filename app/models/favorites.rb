class Favorites < ActiveRecord::Base
  
  attr_accessible :user_id, :post_id
  
  belongs_to :post, class_name: "::Posts::Post"
  belongs_to :user
end
