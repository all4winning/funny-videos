module Users
  class SessionsController < Devise::SessionsController
    def destroy
      super
    end
  end
end