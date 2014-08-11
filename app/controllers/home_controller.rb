class HomeController < ApplicationController
  def index
    @videos = Posts::Video.published.paginate(:page => params[:page], :per_page => Rails.configuration.videos_per_page)
    @top_videos = Posts::Video.top_posts.published.limit(6)
  end
end
