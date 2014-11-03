Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  root 'welcome#index'
  resources :users

  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          post :wui_alert
          post :wui_response
        end
      end

      post '/sign_up', to: 'registrations#create'
    end
  end
end
