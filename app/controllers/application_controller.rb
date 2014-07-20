class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :categories
  before_filter :notifications
  before_filter :top_users

  def authenticate_admin_user!
    redirect_to '/' and return if user_signed_in? && !current_user.admin?

    authenticate_user!
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end

  private

  def categories
    @categories ||= Category.all
  end

  def notifications
    if current_user
      @notifications_not_seen_count = current_user.notifications.newer_than(current_user.last_seen_notifications).count
    else
      @notifications_not_seen_count = 0
    end
  end

  def top_users
    if current_user
      @top_users = User.top_users.not_followed_by(current_user.id).limit(5)
    else
      @top_users = User.top_users.limit(5)
    end 
  end
end