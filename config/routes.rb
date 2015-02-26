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

      post '/sessions', to: 'sessions#create'
      resources :users do
        collection do
          get :me
        end
      end
      resources :wuis, only: [:create, :update]
    end
  end
end
