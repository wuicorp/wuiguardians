Rails.application.routes.draw do
  use_doorkeeper

  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      resources :users
      post '/sign_up', to: 'registrations#create'
      resources :wuis, only: [:create, :update]
    end
  end
end
