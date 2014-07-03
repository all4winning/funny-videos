module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in @user, :event => :authentication #this will throw if @user is not activated
        redirect_to feed_users_path
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        set_flash_message(:error, :failure, :kind => "Facebook") if is_navigational_format?
        redirect_to root_path
      end
    end
  end
end