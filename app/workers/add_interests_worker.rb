class AddInterestsWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false
  
  def perform(user_id)
    FunnyVideos::Interests::Add.new(user_id).perform
  end
end