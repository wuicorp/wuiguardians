Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users

  scope :api do
    scope :v1 do
      use_doorkeeper do
        controllers applications: 'oauth/applications'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      use_doorkeeper do
        controllers applications: 'oauth/applications'
      end

      resources :sessions, only: [:create]
      resources :users, only: [:show, :update]
      resources :vehicles, only: [:index, :create, :update, :destroy]
      resources :wuis, only: [:index, :create, :update]
    end
  end
end
