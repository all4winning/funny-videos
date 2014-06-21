module FunnyVideos
  module NotificationSettings
    class Add
      def initialize(user_id)
        @user_id = user_id
      end

      def perform
        User::EDITABLE_NOTIFICATIONS.each do |notification_type|
          ::NotificationSetting.create(user_id: @user_id, notification_type: notification_type, editable: true)
        end
      end
    end
  end
end