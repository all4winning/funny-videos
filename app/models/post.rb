class Post < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_many :post_views
  has_many :reputations
  has_many :favorites, class_name: "::Favorite"
  belongs_to :user, counter_cache: true

  attr_readonly :post_views_count

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :history]

  def favorized_by?(user)
    favorites.where(user_id: user.id).count > 0
  end
end
