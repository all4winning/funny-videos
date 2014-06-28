class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :load_user, except: [:index]

  def index
    @users = User.all
  end

  def show
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
