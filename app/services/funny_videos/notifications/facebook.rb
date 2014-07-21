module FunnyVideos
  module Notifications
    class Facebook

      def self.video_published(params)
        self.post_to_facebook(params)
      end

      def self.video_liked(params)
        self.post_to_facebook(params)
      end

      def self.video_added_to_favorites(params)
        self.post_to_facebook(params)
      end

      private

      def self.facebook_message(type)
        case type
        when :video_published
          'Published a video on FunSlave'
        when :video_liked
          'Liked a video on FunSlave'
        when :video_added_to_favorites
          'Added a video to his favorites on FunSlave'
        end
      end

      def self.post_to_facebook(type, params)
        ::PostToFacebookWorker.perform_async(
          facebook_message(params[:type]),
          params[:user].fb_token,
          params[:about].image.url(:video),
          Rails.application.routes.url_helpers.posts_video_path(params[:about]),
          params[:about].title
        )
      end
    end
  end
end