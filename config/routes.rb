require 'sidekiq/web'

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
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
        post :video_counter
        post :clicks
      end
      member do
        post :like
        post :unlike
        post :add_to_favorites
        post :remove_from_favorites
      end
    end
    resources :categories, only: [:show] do
    end
  end

  resources :users, only: [:index, :show] do
    member do
      post :follow
      post :unfollow
      get :my_videos
      get :favorites
    end
    collection do
      get :feed   
    end
    resources :interests, only: [:index] do
      collection do
        post :update_all
      end
    end  
    resources :notification_settings, only: [:index] do
      collection do
        post :update_all
      end
    end 

    resources :notifications, only: [:index] 
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end