class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  layout false

  def index
    @notifications = current_user.notifications.paginate(page: params[:page], per_page: 20)
    current_user.update_attribute(:last_seen_notifications, Time.now)
  end
end