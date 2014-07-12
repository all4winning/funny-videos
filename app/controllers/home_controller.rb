class HomeController < ApplicationController
  def index
    @videos = Posts::Video.published
  end
end
