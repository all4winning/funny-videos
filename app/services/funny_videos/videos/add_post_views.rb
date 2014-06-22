module FunnyVideos
  module Videos
    class AddPostViews

      def initialize(user, video, ip)
        @user = user
        @video = video
        @ip = ip
      end

      def perform
        add_views
      end

      private

      def add_views
        AddPostViewsWorker.perform_async(user_id, @video.id, @ip)
      end

      def user_id
        @user.nil? ? -1 : @user.id
      end
    end
  end
end