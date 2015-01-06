Rails.application.routes.draw do
  devise_for :developers

  use_doorkeeper do
    controllers applications: 'oauth/applications'
  end

  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      resources :users
      post '/sign_up', to: 'registrations#create'
      resources :wuis, only: [:create, :update]
    end
  end
end
