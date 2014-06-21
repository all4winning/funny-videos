module FunnyVideos
  module Interests
    class Add

      def initialize(user_id)
        @user_id = user_id
      end

      def perform
        Category.find_each do |category|
          Interest.create(user_id: @user_id, category_id: category.id)
        end
      end
    end
  end
end