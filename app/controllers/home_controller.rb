class HomeController < ApplicationController
  def index
      @videos = Posts::Video.all
  end
  
  def search
      @query = params[:query]
      @videos = Posts::Video.where('LOWER(title) LIKE ?', "%#{params[:query].downcase}%")
  end
end
