class HomeController < ApplicationController
  def index
    @videos = Posts::Video.published
    @top_videos = Posts::Video.top_posts.published.limit(6)
  end
end
