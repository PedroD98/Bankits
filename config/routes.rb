Rails.application.routes.draw do
  get "transactions/create"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  devise_scope :user do
    unauthenticated :user do
      root 'devise/sessions#new'
    end
  end

  authenticated :user do
    root "statements#index", as: :authenticated_root
  end

  resources :statements, only: %i[index]
  resources :deposits, only: %i[create]
  resources :withdrawals, only: %i[create]
  resources :transfers, only: %i[create]
  resources :manager_visits, only: %i[new create]
end
