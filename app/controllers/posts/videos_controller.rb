module Posts
  class VideosController < ApplicationController
    before_filter :authenticate_user!, :except => [:show]
    before_filter :load_video, only: [:show, :destroy]

    def index
      @videos = Posts::Video.all
    end

    def show
    end

    def new
      @video = Posts::Video.new
    end

    def create
      FunnyVideos::Videos::AddVideo.new(params, current_user).perform
      flash[:notice] = "Your video will be added shortly. You will be notified when ready."
      redirect_to action: "index"
    end

    def destroy
    end

    private 

    def load_video
      @video = Posts::Video.friendly.find(params[:id])
    end
  end
end