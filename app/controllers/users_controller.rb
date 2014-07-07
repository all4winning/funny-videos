class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :load_user, except: [:index, :feed]

  def index
    @users = User.all
  end

  def show
  end
  
  def feed
    @videos = Posts::Video.joins('LEFT OUTER JOIN follows ON posts.user_id = follows.followable_id').
                           joins('INNER JOIN categories_posts on posts.id=categories_posts.post_id').
                           joins('LEFT OUTER JOIN interests ON categories_posts.category_id = interests.category_id').
                           where('(follows.follower_id=?)OR(interests.selected=TRUE and interests.user_id=?)', current_user.id, current_user.id) 
  end
  
  def my_videos
    @videos = Posts::Video.where('posts.user_id =?', current_user.id)
  end

  def favorites
    @videos = Posts::Video.joins('INNER JOIN favorites ON posts.id = favorites.post_id').
                           where('(favorites.user_id=?)', current_user.id)
  end

  def follow
    current_user.follow(@user)
  end

  def unfollow
    current_user.stop_following(@user)
  end

  private

  def load_user
    @user = User.friendly.find(params[:id])
  end
end
