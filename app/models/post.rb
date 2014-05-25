class Post < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  belongs_to :user

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :history]
end
