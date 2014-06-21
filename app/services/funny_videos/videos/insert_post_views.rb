module FunnyVideos
  module Videos
    class InsertPostViews

      def initialize(user_id, video_id, ip)
        @user_id = user_id
        @video_id = video_id
        @ip = ip
      end

      def perform
        insert_views
      end

      private

      def insert_views
        upsert = ::Upsert.new(PostView.connection, PostView.table_name)
        upsert.row({user_id: @user_id, post_id: @video_id, ip: @ip}, created_at: Time.now, updated_at: Time.now)
        PostView.where(user_id: @user_id, post_id: @video_id, ip: @ip).update_all("nr_views = nr_views + 1")
      end
    end
  end
end