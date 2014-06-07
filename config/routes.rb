Rails.application.routes.draw do
  root "home#index"
  
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    delete '/users/logout'  => 'users/sessions#destroy',   :as => :destroy_user_session
  end

  namespace :posts do
    resources :videos, except: [:edit, :update]
  end
end