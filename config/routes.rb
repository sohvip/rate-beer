Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [ :index, :new, :create, :destroy ]
  resources :styles
  resource :session, only: [ :new, :create, :destroy ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "breweries#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "signup", to: "users#new"
  get "signin", to: "sessions#new"
  delete "signout", to: "sessions#destroy"

  resources :places, only: [:index, :show]
  post "places", to: "places#search"

  resources :breweries do
    post 'toggle_activity', on: :member
  end

  get "beerlist", to: "beers#list"

  get "brewerylist", to: "breweries#list"

  resources :users do
    member do
      patch :close
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
