class PostToFacebookWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false

  def perform(message, token,  image_path, url, title)
    me = FbGraph::User.me(token).fetch
    me.feed!(
      :message => message,
      :picture => "http://localhost:3000/" + image_path,
      :link => "http://localhost:3000/" + url,
      :name => title
    )
  end
end