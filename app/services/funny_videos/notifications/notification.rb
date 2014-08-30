module FunnyVideos
  module Notifications
    class Notification

      def self.video_published(params)
        ::Notification.create(user: params[:user], about: params[:about], notification_type: params[:type])
      end

      def self.video_liked(params)
        if params[:user] != params[:about].user
          ::Notification.create(user: params[:user], about: params[:about], notification_type: params[:type])
        end
      end

      def self.video_added_to_favorites(params)
        if params[:user] != params[:about].user
          ::Notification.create(user: params[:user], about: params[:about], notification_type: params[:type])
        end
      end
    end
  end
end