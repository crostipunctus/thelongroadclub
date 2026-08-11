Rails.application.routes.draw do
  root "home#index"

  resource :registration, only: %i[new create]
  get "signup", to: "registrations#new"
  resource :session, only: %i[new create destroy]
  get "login", to: "sessions#new"
  delete "logout", to: "sessions#destroy"

  resources :users, only: :show, param: :username
  resources :discussions, param: :slug do
    resources :posts, only: :create
    resource :bookmark, only: %i[create destroy]
  end
  resources :posts, only: %i[update destroy]

  resources :events, only: %i[index show], param: :slug do
    resource :rsvp, only: %i[create destroy], controller: :event_rsvps
  end
  resources :garage_features, only: %i[index show], path: "garage", param: :slug
  resources :guides, only: %i[index show], param: :slug
  resources :newsletter_subscriptions, only: :create
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
