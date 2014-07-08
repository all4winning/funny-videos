class Reputation < ActiveRecord::Base
  
  attr_accessible :user_id, :post_id, :like, :unlike
  
   belongs_to :user
   belongs_to :post
end
