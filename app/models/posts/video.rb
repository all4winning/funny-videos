module Posts
  class Video < Post
    require "open-uri"

    attr_accessible :image

    has_attached_file :image, :default_url => "/images/videos/:style/missing.png"
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    def self.yt_session
      @yt_session ||= YouTubeIt::Client.new(:username => YouTubeITConfig.username , :password => YouTubeITConfig.password , :dev_key => YouTubeITConfig.dev_key)    
    end

    def self.process_uri(uri)
      require 'open-uri'
      require 'open_uri_redirections'
      uri = uri.gsub(/default/, '0')
      open(uri, :allow_redirections => :safe) do |r|
        URI.parse(r.base_uri.to_s)
      end
    end
  end
end