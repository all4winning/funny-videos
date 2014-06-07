module Posts
  class VideosController < ApplicationController
    before_filter :authenticate_user!, :except => [:show]
    before_filter :load_video, only: [:show, :destroy]
    before_filter :init_video, only: [:new, :create]

    def index
      @videos = Posts::Video.all
    end

    def show
      @video = Posts::Video.find(params[:id])
    end

    def new
    end

    def create
      youtube_video = Posts::Video.yt_session.video_by(params[:youtube_url])
      @video.title = youtube_video.title
      @video.description = youtube_video.description
      @video.user = current_user
      @video.image_url = params[:youtube_url]
      @video.image = Posts::Video.process_uri(youtube_video.thumbnails.first.url)
      @video.save
    end

    def destroy
    end

    private 

    def load_video
      @video = Posts::Video.find(params[:id])
    end

    def init_video
      @video = Posts::Video.new
    end
  end
end