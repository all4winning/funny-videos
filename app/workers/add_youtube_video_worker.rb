class AddYoutubeVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false
  
  def perform(video_id)
    Videos::AddYoutubeVideo.new(video_id).perform
  end
end