class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts

  extend FriendlyId
  friendly_id :name, :use => [:slugged, :history]
end
