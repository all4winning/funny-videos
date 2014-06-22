class User < ActiveRecord::Base

  EDITABLE_NOTIFICATIONS = [:newsletter, :follow]

  attr_accessible :image
  attr_readonly :post_views_count, :posts_count
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :posts
  has_many :interests
  has_many :notification_settings
  has_many :post_views

  has_attached_file :image, :default_url => "/images/users/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  extend FriendlyId
  friendly_id :username, :use => [:slugged, :history]

  acts_as_followable
  acts_as_followable

  after_create :add_interests
  after_create :add_notification_settings

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.first_name = auth.info.name   # assuming the user model has a name
      user.image = process_uri(auth.info.image) if auth.info.image.present?
      user.username = auth.info.name
      user.confirmed_at = Time.now if user.confirmed_at.nil?
      user.save
    end
  end

  def notifications
     @notifications ||= FunnyVideos::NotificationSettings::NotificationSetting.new(self)
  end

  def enabled_notification?(notification, type)
    notifications[type][notification]
  end

  # def enable_notification(notification, type)
  #   notifications[type][notification] = true
  #   notifications[type].save
  # end

  # def disable_notification(notification, type)
  #   notifications[type][notification] = false
  #   notifications[type].save
  # end

  private

  def self.process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, :allow_redirections => :safe) do |r|
      URI.parse(r.base_uri.to_s)
    end
  end

  def add_interests
    AddInterestsWorker.perform_async(self.id)
  end

  def add_notification_settings
    AddNotificationSettingsWorker.perform_async(self.id)
  end
end
