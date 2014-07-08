module Posts
  class VideosController < ApplicationController
    before_filter :authenticate_user!, :except => [:show, :search, :latest_videos, :popular_videos, :trending_videos]
    before_filter :load_video, only: [:show, :destroy, :like, :unlike]
    before_filter :reputation, only: [:show]

    def index
      @videos = Posts::Video.all
    end

    def show
      @related_videos = Posts::Video.select('COUNT(*) AS total, posts.*').
                             joins('LEFT OUTER JOIN post_views ON posts.id = post_views.post_id').
                             joins(:categories).
                             where("categories.id in (#{@video.categories.pluck(:id).join(',')})").
                             group('posts.id').
                             order('total DESC')                               
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
      rep = Reputation.find_by_user_id_and_post_id(current_user.id, @video.id)
      if Reputation.exists?(rep)
        if rep.like == 0
          rep.like = 1
          rep.unlike = 0
          rep.save()
        end
      else
        Reputation.create(user_id: current_user.id, post_id: params[:id], like: 1, unlike: 0)  
      end
      reputation
    end
    
    def unlike
      rep = Reputation.find_by_user_id_and_post_id(current_user.id, @video.id)
      if Reputation.exists?(rep)
        if rep.unlike == 0
          rep.unlike = 1
          rep.like = 0
          rep.save()
        end
      else
        Reputation.create(user_id: current_user.id, post_id: params[:id], like: 0, unlike: 1)  
      end
      reputation
    end
    
    def search
      @videos = Posts::Video.where('LOWER(title) LIKE ?', "%#{params[:query].downcase}%")
    end
    
    def add_to_favorites
      Favorite.find_or_create_by_user_id_and_post_id(current_user.id, params[:id])
    end
    
    def remove_from_favorites
      fav=Favorite.find_by_user_id_and_post_id(current_user.id, params[:id])
      fav.destroy
    end
    
    def latest_videos
      @videos = Posts::Video.order(created_at: :desc)
    end
    
    def popular_videos
      @videos = Posts::Video.select('COUNT(*) AS total, posts.*').
                             joins('LEFT OUTER JOIN post_views ON posts.id = post_views.post_id').
                             group('posts.id').
                             order('total DESC')
    end

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
    
    def reputation
      rep = Reputation.select("SUM(reputations.like) as likes, SUM(unlike) as unlikes").
                               group('post_id').
                               where('post_id =?',@video.id)
      if rep.exists?
        @reputation=rep[0].likes - rep[0].unlikes
      else
        @reputation=0
      end                                                   
    end
  end
end