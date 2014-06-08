module Videos
  class AddYoutubeVideo

    def initialize(url, user_id)
      @url = url
      @user_id = user_id
    end

    def perform
      add_video
    end

    private

    def add_video
      youtube_video = youtube_client.video_by(@url)
      video.title = youtube_video.title
      video.description = youtube_video.description
      video.video_url = youtube_video.embed_url
      video.video_id = youtube_video.unique_id
      video.user_id = @user_id
      video.image = image_url(youtube_video.thumbnails.first.url)
      video.save
    end

    def video
      @video ||= Posts::Video.new
    end

    def image_url(default_url)
      require 'open-uri'
      require 'open_uri_redirections'
      default_url = default_url.gsub(/default/, '0')
      open(default_url, :allow_redirections => :safe) do |r|
        URI.parse(r.base_uri.to_s)
      end
    end

    def youtube_client
      @youtube_client ||= YouTubeIt::Client.new(
                            :username => YouTubeITConfig.username , 
                            :password => YouTubeITConfig.password , 
                            :dev_key => YouTubeITConfig.dev_key
                          )
    end
  end
end