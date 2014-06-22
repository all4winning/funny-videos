class PostView < ActiveRecord::Base

  attr_accessible :user_id, :post_id, :ip, :nr_views

  belongs_to :user, counter_cache: true
  belongs_to :post, counter_cache: true
  
end
