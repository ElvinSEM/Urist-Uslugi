Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  get "up" => "rails/health#show", as: :rails_health_check
  get "/health", to: "health#show"
  get "/sitemap.xml", to: "sitemaps#show", defaults: { format: :xml }

  namespace :admin do
    root "dashboard#index"
    resources :users
    resources :categories
    resources :services
    resources :service_requests do
      member { patch :transition }
    end
  end

  resources :categories, only: :show, param: :slug
  resources :services, only: %i[index show], param: :slug
  resources :service_requests, only: %i[index show new create]
  resources :notifications, only: %i[index show]

  namespace :api do
    namespace :v1 do
      post "/auth/login", to: "auth#create"
      delete "/auth/logout", to: "auth#destroy"

      resources :categories, only: %i[index show], param: :slug
      resources :services, only: %i[index show create update destroy], param: :slug
      resources :service_requests do
        member { patch :transition }
      end
      resources :notifications, only: %i[index show]
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root "services#index"
end
