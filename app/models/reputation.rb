class Reputation < ActiveRecord::Base
  
  attr_accessible :user_id, :post_id
  
   belongs_to :user
   belongs_to :post, class_name: "::Posts::Post"
end
