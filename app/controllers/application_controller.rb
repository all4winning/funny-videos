class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :categories

  def authenticate_admin_user!
    redirect_to '/' and return if user_signed_in? && !current_user.admin?

    authenticate_user!
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end

  private

  def categories
    @categories ||= Category.all
  end
end
