module ApplicationHelper
  def notifications_count_class(not_seen_count)
    not_seen_count > 0 ? "" : "hidden"
  end
end
