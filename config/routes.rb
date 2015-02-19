Rails.application.routes.draw do
  devise_for :users

  use_doorkeeper do
    controllers applications: 'oauth/applications'
  end

  root 'welcome#index'

  namespace :api do
    namespace :v1 do
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
