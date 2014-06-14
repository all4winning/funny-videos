class AddVimeoVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false
  
  def perform(video_id)
    Videos::AddVimeoVideo.new(video_id).perform
  end
end