module FunnyVideos
  module Interests
    class UpdateAllForm

      def initialize(user)
        @user = user
      end

      def submit(params)
        if params
          @user.interests.each do |interest|
            value = params[interest.id.to_s]
            interest.update_attribute(:selected, value) if value.present?
          end
          true
        else
          false
        end
      end
    end
  end
end