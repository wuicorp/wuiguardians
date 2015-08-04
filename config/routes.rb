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
      resources :flags, only: [:create]

      resources :wuis, only: [:create, :update] do
        collection do
          get 'sent'
          get 'received'
        end
      end
    end
  end
end
