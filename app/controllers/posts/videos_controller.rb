module Posts
  class VideosController < ApplicationController
    before_filter :authenticate_user!, :except => [:show, :search, :latest_videos, :popular_videos, :trending_videos]
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
    
    def latest_videos
      @videos = Posts::Video.order(created_at: :desc)
    end
    
    def popular_videos
      @videos = Posts::Video.select('COUNT(*) AS total, posts.*').
                             joins('LEFT OUTER JOIN post_views ON posts.id = post_views.post_id').
                             group('posts.id').
                             order('total DESC')

    def trending_videos
      @videos = Posts::Video.select('COUNT(*) AS total, posts.*').
                             joins('LEFT OUTER JOIN post_views ON posts.id = post_views.post_id').
                             where('post_views.updated_at >= ?', 1.week.ago).
                             group('posts.id').
                             order('total DESC')
    end

    private 

    def load_video
      @video = Posts::Video.friendly.find(params[:id])
    end
  end
end