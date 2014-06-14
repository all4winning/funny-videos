module Posts
  class Video < Post
    attr_accessible :image

    has_attached_file :image, 
                      :default_url => "/images/videos/:style/missing.png",
                      :processors => [:watermark],
                      :styles => {
                        video: {
                          geometry: "600x315",
                          extent: "600x315",
                          watermarks:[
                            {
                              path: "#{Rails.root}/public/images/watermark.png",
                              position: "west"
                            }
                          ]
                        }
                      }
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  end
end