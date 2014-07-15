module FunnyVideos
  module Videos
    class AddYoutubeVideo
      IMAGE_URL = "http://img.youtube.com/vi/video_id/maxresdefault.jpg"
      FALLBACK_IMAGE_URL = "http://img.youtube.com/vi/video_id/0.jpg"

      def initialize(video)
        @video = video
      end

      def perform
        add_video
        send_notification
      end

      private

      def add_video
        @video.title = youtube_video.title unless @video.title.present?
        @video.description = youtube_video.description unless @video.description.present?
        @video.video_embed_url = youtube_video.embed_url
        @video.video_id = youtube_video.unique_id
        begin
          @video.image = image_url
        rescue Exception => e
          @video.image = fallback_image_url
        end
        @video.publish
      end

      def youtube_video
        @youtube_video ||= youtube_client.video_by(@video.video_url)
      end

      def image_url
        URI.parse(IMAGE_URL.gsub("video_id", youtube_video.unique_id))
      end

      def fallback_image_url
        URI.parse(FALLBACK_IMAGE_URL.gsub("video_id", youtube_video.unique_id))
      end

      def youtube_client
        @youtube_client ||= YouTubeIt::Client.new(
                              :username => YouTubeITConfig.username , 
                              :password => YouTubeITConfig.password , 
                              :dev_key => YouTubeITConfig.dev_key
                            )
      end

      def send_notification
        FunnyVideos::Notifications::NotificationService.broadcast({type: :video_published, user: @video.user, about: @video})
      end
    end
  end
end