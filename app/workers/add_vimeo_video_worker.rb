class AddVimeoVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false
  
  def perform(url, user_id)
    Videos::AddVimeoVideo.new(url, user_id).perform
  end
end