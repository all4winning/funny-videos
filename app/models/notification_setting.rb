class NotificationSetting < ActiveRecord::Base

  attr_accessible :user_id, :notification_type, :editable
  belongs_to :user

  scope :can_be_edited, where(editable: true)
end
