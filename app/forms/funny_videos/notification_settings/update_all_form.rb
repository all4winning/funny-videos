module FunnyVideos
  module NotificationSettings
    class UpdateAllForm

      def initialize(user)
        @user = user
      end

      def submit(params)
        if params
          @user.privacy_settings.can_be_edited.each do |notification|
            value = params[notification.id.to_s]
            notification.update_attribute(:email_enabled, value) if value.present?
          end
          true
        else
          false
        end
      end
    end
  end
end