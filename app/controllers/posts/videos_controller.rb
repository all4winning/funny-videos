module Posts
  class VideosController < ApplicationController
    before_filter :authenticate_user!, :except => [:show, :search, :latest_videos, :popular_videos, :trending_videos, :video_counter, :clicks]
    before_filter :load_video, only: [:show, :destroy, :like, :unlike, :add_to_favorites, :remove_from_favorites]


    def index
      @videos = Posts::Video.published.paginate(:page => params[:page], :per_page => Rails.configuration.videos_per_page)
    end

    def show
      @related_videos = @video.related_videos.limit(5)  
      @popular_videos = Posts::Video.popular_videos.published.limit(6)                         
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
    
    def like
      @video.like(current_user.id)
      FunnyVideos::Notifications::NotificationService.broadcast({type: :video_liked, user: current_user, about: @video})
    end
    
    def unlike
      @video.unlike(current_user.id)
    end
    
    def search
      @videos = Posts::Video.where('LOWER(title) LIKE ?', "%#{params[:query].downcase}%").published.paginate(:page => params[:page], :per_page => Rails.configuration.videos_per_page)
    end
    
    def add_to_favorites
      Favorite.find_or_create_by_user_id_and_post_id(current_user.id, @video.id)
      FunnyVideos::Notifications::NotificationService.broadcast({type: :video_added_to_favorites, user: current_user, about: @video})
    end
    
    def remove_from_favorites
      fav=Favorite.find_by_user_id_and_post_id(current_user.id, @video.id)
      fav.destroy
    end
    
    def latest_videos
      @videos = Posts::Video.order(created_at: :desc).published.paginate(:page => params[:page], :per_page => Rails.configuration.videos_per_page)
    end
    
    def popular_videos
      @videos = Posts::Video.popular_videos.published.paginate(:page => params[:page], :per_page => Rails.configuration.videos_per_page)
    end

    def trending_videos
      @videos = Posts::Video.trending_videos.published.paginate(:page => params[:page], :per_page => Rails.configuration.videos_per_page)
    end
    
    def video_counter
      require "csv"
      data = {}
      path = Rails.root.to_s + "/counter.csv"
      begin
        CSV.foreach(path) do |row|
          name, value = row
          data[name] = value
        end
        data['views'] = data['views'].to_i + 1
      rescue
        data['views'] = 1
      end  
      CSV.open(path, "wb") do |csv|
        csv << ["views", data['views']]       
      end
      
      render nothing: true
    end
    
    def clicks
      require "csv"
      data = {}
      path = Rails.root.to_s + "/clicks.csv"
      begin
        CSV.foreach(path) do |row|
          name, value = row
          data[name] = value
        end
        data['clicks'] = data['clicks'].to_i + 1
      rescue
        data['clicks'] = 1  
      end  
      CSV.open(path, "wb") do |csv|
        csv << ["clicks", data['clicks']]       
      end     
      render nothing: true
    end

    private 

    def load_video
      @video = Posts::Video.published.friendly.find(params[:id])
    end
    
  end
end