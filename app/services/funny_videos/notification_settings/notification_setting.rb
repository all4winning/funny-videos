module FunnyVideos
  module NotificationSettings
    class NotificationSetting
      
      def initialize(user)
        @user = user
        @notifications = {}
      end

      def [](type)
        @notifications[type] ||= @user.notification_settings.find_or_create_by_notification_type(type)
      end
    end
  end
end