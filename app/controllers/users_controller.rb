class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :load_user, only: [:index]

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
  end

  def follow
  end

  def unfollow
  end

  private

  def load_user
    @user = User.find(params[:id])
  end
end
