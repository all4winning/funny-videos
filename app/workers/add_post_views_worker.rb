class AddPostViewsWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false
  
  def perform(user_id, video_id, ip)
    FunnyVideos::Videos::InsertPostViews.new(user_id, video_id, ip).perform
  end
end