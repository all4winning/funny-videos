module FunnyVideos
  module Videos
    class AddVimeoVideo
      EMBED_URL = "http://player.vimeo.com/video/"

      def initialize(video)
        @video = video
      end

      def perform
        add_video
        send_notification
      end

      private

      def add_video
        @video.title = vimeo_video["title"] unless @video.title.present?
        @video.description = vimeo_video["description"] unless @video.description.present?
        @video.video_embed_url = "#{EMBED_URL}#{vimeo_video['id']}"
        @video.video_id = vimeo_video["id"]
        @video.image = vimeo_video["thumbnail_large"]
        @video.publish
      end

      def vimeo_video
        @vimeo_video ||= Vimeo::Simple::Video.info(video_id).first
      end

      def video_id
        @video.video_url.split("?")[0].split("#")[0].split("/").last
      end

      def send_notification
        FunnyVideos::Notifications::NotificationService.broadcast({type: :video_published, user: @video.user, about: @video})
      end
    end
  end
end