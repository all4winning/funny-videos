class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :categories
  before_filter :notifications
  before_filter :trending_videos
  before_filter :latest_videos
  before_filter :popular_videos

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

  def latest_videos
    @latest_videos ||= Posts::Video.order(created_at: :desc).published.limit(3)
  end
  
  def popular_videos
    @popular_videos ||= Posts::Video.popular_videos.published.limit(3)
  end

  def trending_videos
    @trending_videos ||= Posts::Video.trending_videos.published.limit(3)
  end
end
