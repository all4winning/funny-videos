module FunnyVideos
  module Notifications
    class NotificationService

      NOTIFIERS = %w(FunnyVideos::Notifications::Email FunnyVideos::Notifications::Facebook FunnyVideos::Notifications::Notification)

      def self.broadcast(params)
        NOTIFIERS.each do |n|
          if enabled_notification?(n, params[:type], params[:user])
            n.constantize.send(params[:type], params)
          end
        end
      end

      def self.enabled_notification?(n, type, user)
        n.constantize.respond_to?(type) && user.enabled_notification?(notification_to_field(n), type)
      end

      def self.notification_to_field(notification)
        case notification
        when "FunnyVideos::Notifications::Email"
          :email_enabled
        when "FunnyVideos::Notifications::Facebook"
          :facebook_enabled
        when "FunnyVideos::Notifications::Notification"
          :notification_enabled
        else
          notification
        end
      end
    end
  end
end
