Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  root 'welcome#index'
  resources :users

  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          get :connect
        end
      end
    end
  end
end
