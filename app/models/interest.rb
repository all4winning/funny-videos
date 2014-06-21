class Interest < ActiveRecord::Base

  attr_accessible :user_id, :category_id
  
  belongs_to :category
  belongs_to :user

end
