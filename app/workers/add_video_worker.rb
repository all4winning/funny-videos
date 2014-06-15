class AddVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false
  
  def perform(video_id)
    FunnyVideos::Videos::AddVideo.new(video_id).perform
  end
end