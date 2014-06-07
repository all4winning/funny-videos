class User < ActiveRecord::Base
  require "open-uri"

  attr_accessible :image
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :posts

  has_attached_file :image, :default_url => "/images/users/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  extend FriendlyId
  friendly_id :username, :use => [:slugged, :history]

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.name   # assuming the user model has a name
      user.image = process_uri(auth.info.image) if auth.info.image.present?
      user.username = auth.info.name
      user.confirmed_at = Time.now if user.confirmed_at.nil?
      user.save
    end
  end

  private

  def self.process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, :allow_redirections => :safe) do |r|
      URI.parse(r.base_uri.to_s)
    end
  end
end
