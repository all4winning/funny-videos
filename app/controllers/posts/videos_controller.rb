module Posts
  class VideosController < ApplicationController
    before_filter :authenticate_user!, :except => [:show, :search]
    before_filter :load_video, only: [:show, :destroy]

    def index
      @videos = Posts::Video.all
    end

    def show
      FunnyVideos::Videos::AddPostViews.new(current_user, @video, request.remote_ip).perform
    end

    def new
      @video = Posts::Video.new
    end

    def create
      @add_form = FunnyVideos::Videos::AddForm.new(current_user)
      if @add_form.submit(params)
        AddVideoWorker.perform_async(@add_form.video.id)
        flash[:notice] = "Your video will be added shortly. You will be notified when ready."
        redirect_to action: "index"
      else
        flash[:error] = "Correct the errors and try again."
        redirect_to action: "new"
      end
    end

    def destroy
    end
    
    def search
      @videos = Posts::Video.where('LOWER(title) LIKE ?', "%#{params[:query].downcase}%")
    end

    private 

    def load_video
      @video = Posts::Video.friendly.find(params[:id])
    end
  end
end