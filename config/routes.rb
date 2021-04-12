Rails.application.routes.draw do
  root to: "static#home"

  namespace :api, defaults: { format: :json} do
    namespace :v1 do
      resources :events, only: [:show]
      resources :sessions, only: [:create]
        delete :logout, to: "sessions#logout"
        get :logged_in, to: "sessions#logged_in"
      resources :registrations, only: [:create]
      resources :villages, only: [:index]
    end
  end
end
