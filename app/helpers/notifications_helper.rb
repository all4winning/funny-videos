module NotificationsHelper
  def notification_class(index)
    index == 0 ? "first" : ""
  end
end