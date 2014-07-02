class HomeController < ApplicationController
  def index
    if user_signed_in?
      @videos = Posts::Video.all
      @videos_folower_id = @videos.joins('INNER JOIN follows ON posts.user_id = follows.followable_id').
                             where('follows.follower_id=?', current_user.id ).
                             pluck(:id)
                             #order('posts.created_at DESC')
      @videos_interest_id = @videos.joins('INNER JOIN categories_posts on posts.id=categories_posts.post_id').
                             joins('INNER JOIN interests ON categories_posts.category_id = interests.category_id').
                             where('interests.selected=TRUE and interests.user_id=?', current_user.id ).
                             pluck(:id) 
      @videos = @videos.where('posts.id in (?) or posts.id in (?)', @videos_folower_id, @videos_interest_id).
                        order('posts.created_at DESC')                                           
    else
      @videos = Posts::Video.all
    end 
  end
end
