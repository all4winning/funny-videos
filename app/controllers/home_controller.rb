class HomeController < ApplicationController
  def index
    if user_signed_in?
      @videos = Posts::Video.joins('INNER JOIN follows ON posts.user_id = follows.followable_id').
                             where('follows.follower_id=?', current_user.id ).
                             order('posts.created_at DESC')
    else
      @videos = Posts::Video.all
    end 
  end
end
