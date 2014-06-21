module FunnyVideos
  module Interests
    class AddNew

      def initialize(category_id)
        @category_id = category_id
      end

      def perform
        User.find_each do |user|
          Interest.create(user_id: user.id, category_id: @category_id)
        end
      end
    end
  end
end