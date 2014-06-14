module FunnyVideos
  module Videos
    class AddForm

      def initialize(user)
        @user = user
      end

      def submit(params)
        video.title = params[:title]
        video.description = params[:description]
        video.categories << Category.find(params[:category])
        video.video_url = params[:video_url]
        video.video_type = video_type(params[:video_url])
        video.user = @user
        video.save
      end

      def video
        @video ||= Posts::Video.new
      end

      private

      def video_type(url)
        if url.include?("youtube")
          "youtube"
        elsif url.include?("vimeo")
          "vimeo"
        else
          nil
        end          
      end
    end
  end
end