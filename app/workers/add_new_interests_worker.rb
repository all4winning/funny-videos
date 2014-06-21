class AddNewInterestsWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false
  
  def perform(category_id)
    FunnyVideos::Interests::AddNew.new(category_id).perform
  end
end