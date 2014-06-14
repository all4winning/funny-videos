class Category < ActiveRecord::Base
  has_and_belongs_to_many :posts
  attr_accessible :name

  extend FriendlyId
  friendly_id :name, :use => [:slugged, :history]
end
