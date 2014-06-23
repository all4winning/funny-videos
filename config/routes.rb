require 'sidekiq/web'

Rails.application.routes.draw do
  root "home#index"
  
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    delete '/users/logout'  => 'users/sessions#destroy',   :as => :destroy_user_session
  end
  
  namespace :posts do
    resources :videos, except: [:edit, :update] do
      collection do
        get :search
        get :latest_videos
        get :popular_videos
        get :trending_videos
      end
    end
  end

  resources :users, only: [:index, :show] do
    member do
      post :follow
      post :unfollow
    end
    resources :interests, only: [:index] do
      collection do
        post :update_all
      end
    end
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end