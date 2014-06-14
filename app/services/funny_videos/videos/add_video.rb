module FunnyVideos
  module Videos
    class AddVideo

      def initialize(video)
        @video = video
      end

      def perform
        if @video.video_type == "youtube"
          AddYoutubeVideoWorker.perform_async(@video.id)
        else
          AddVimeoVideoWorker.perform_async(@video.id)
        end
      end
    end
  end
end