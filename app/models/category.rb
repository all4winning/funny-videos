class Category < ActiveRecord::Base

  attr_accessible :name

  extend FriendlyId
  friendly_id :name, :use => [:slugged, :history]

  has_and_belongs_to_many :posts, class_name: "::Posts::Post"
  has_many :interests, :dependent => :delete_all

  after_create :add_new_interests

  private

  def add_new_interests
    AddNewInterestsWorker.perform_async(self.id)
  end
end
