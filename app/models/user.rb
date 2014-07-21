class User < ActiveRecord::Base

  EDITABLE_NOTIFICATIONS = [:newsletter, :follow]

  attr_accessible :image, :fb_token, :fb_token_expires_at
  attr_readonly :post_views_count, :posts_count
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :posts
  has_many :interests
  has_many :reputations
  has_many :privacy_settings, class_name: "NotificationSetting"
  has_many :post_views
  has_many :favorites
  has_many :notifications, order: "created_at desc", class_name: "Notification"
  has_many :followings, foreign_key: "follower_id", dependent: :destroy, class_name: 'Follow'
  has_many :followers, foreign_key: 'followable_id', dependent: :destroy, class_name: 'Follow'

  has_attached_file :image, :default_url => "/images/users/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  extend FriendlyId
  friendly_id :username, :use => [:slugged, :history]

  acts_as_followable
  acts_as_follower

  scope :top_users, order("posts_count desc")
  
  scope :not_followed_by, (lambda do |user_id|
    where("users.id != :user_id AND users.id NOT IN (SELECT followable_id
      FROM follows
      WHERE follower_id = :user_id)", {:user_id => user_id})
  end)

  after_create :add_interests
  after_create :add_notification_settings

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.image = process_uri(auth.info.image) if auth.info.image.present?
      user.username = auth.info.name
      user.confirmed_at = Time.now if user.confirmed_at.nil?
      user.last_seen_notifications = Time.now if user.last_seen_notifications.nil?
      user.fb_token = auth.credentials.token
      user.fb_token_expires_at = Time.at(auth.credentials.expires_at.to_i)
      user.save
    end
  end

  def notification_settings
     @notifications ||= FunnyVideos::NotificationSettings::NotificationSetting.new(self)
  end

  def enabled_notification?(notification, type)
    notification_settings[type][notification]
  end

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
