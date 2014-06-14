class HomeController < ApplicationController
  def index
    @videos = Posts::Video.all
  end
end
