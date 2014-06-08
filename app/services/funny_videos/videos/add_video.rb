module FunnyVideos
  module Videos
    class AddVideo

      def initialize(params, user)
        @params = params
        @user = user
      end

      def perform
        if @params[:youtube_url].present?
          AddYoutubeVideoWorker.perform_async(@params[:youtube_url], @user.id)
        else
          AddVimeoVideoWorker.perform_async(@params[:vimeo_url], @user.id)
        end
      end
    end
  end
end