class HomeController < ApplicationController
  def index
    @videos = Posts::Video.order(created_at: :desc).published.paginate(:page => params[:page], :per_page => Rails.configuration.videos_per_page)
    @popular_videos = Posts::Video.popular_videos.published.limit(6)
  end
end
