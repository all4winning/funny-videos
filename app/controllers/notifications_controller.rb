class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  layout false

  def index
    @notifications = current_user.notifications.paginate(page: params[:page], per_page: 10)
    current_user.update_attribute(:last_seen_notifications, Time.now)
    # respond_to do |format|
    #   format.js  { render_to_string(:partial => 'notifications/notifications', :layout => false, :locals => {:notifications => @notifications}) }
    # end
    # respond_with render_to_string(:partial => 'notifications/notifications', :layout => false, :locals => {:notifications => @notifications})
  end
end