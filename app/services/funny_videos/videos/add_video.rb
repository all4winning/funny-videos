module FunnyVideos
  module Videos
    class AddVideo

      def initialize(video_id)
        @video = Posts::Video.find(video_id)
      end

      def perform
        if @video.video_type == "youtube"
          FunnyVideos::Videos::AddYoutubeVideo.new(@video).perform
        else
          FunnyVideos::Videos::AddVimeoVideo.new(@video).perform
        end
      end
    end
  end
end