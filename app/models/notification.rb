class Notification < ActiveRecord::Base
  attr_accessible :user, :about, :notification_type

  belongs_to :user
  belongs_to :about, polymorphic: true

  validates :user,     presence: true
  validates :about,    presence: true
  validates :notification_type,  presence: true

  scope :newer_than, -> (date) do
    where("created_at > ?", date)
  end 
end
