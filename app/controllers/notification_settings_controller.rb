class NotificationSettingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @notification_settings = current_user.privacy_settings.can_be_edited
  end

  def update_all
    @form = FunnyVideos::NotificationSettings::UpdateAllForm.new(current_user)
    @form.submit(params[:notification_settings])
    flash[:notice] = "success"
    redirect_to action: "index"
  end
end
