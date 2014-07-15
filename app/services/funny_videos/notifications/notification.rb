module FunnyVideos
  module Notifications
    class Notification

      def self.video_published(params)
        ::Notification.create(user: params[:user], about: params[:about], notification_type: params[:type])
      end
    end
  end
end