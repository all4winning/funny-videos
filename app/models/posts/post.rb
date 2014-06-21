module Posts
  class Post < ActiveRecord::Base
    has_and_belongs_to_many :categories
    has_and_belongs_to_many :tags
    has_many :post_views
    belongs_to :user, counter_cache: true

    attr_readonly :post_views_count

    extend FriendlyId
    friendly_id :title, :use => [:slugged, :history]
  end
end
