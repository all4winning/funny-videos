module Posts
  class CategoriesController < ApplicationController
    before_filter :authenticate_user!, :except => [:show]
  
    def show
      @videos = Posts::Video.joins(:categories).
                             where("categories.slug = '#{params[:id]}'").
                             order(created_at: :desc).published 
    end
  
  end
end  