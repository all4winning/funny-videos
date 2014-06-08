class AddYoutubeVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false
  
  def perform(url, user_id)
    Videos::AddYoutubeVideo.new(url, user_id).perform
  end
end