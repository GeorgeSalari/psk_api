# frozen_string_literal: true

Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root API info
  root "health#index"
  get "api", to: "health#index"

  scope :admin do
    post "sign_in", to: "admin_sessions#create"

    get "analytics/overview", to: "admin_analytics#overview"
    get "analytics/pages", to: "admin_analytics#pages"
    get "analytics/events", to: "admin_analytics#events"
    get "analytics/visitors_chart", to: "admin_analytics#visitors_chart"
  end

  resources :certificates, only: [ :index, :create, :update, :destroy ] do
    member do
      patch :toggle_display
    end
    collection do
      patch :reorder
    end
  end

  resources :products, only: [ :index, :show, :create, :update, :destroy ] do
    member do
      patch :toggle_display
    end
    collection do
      patch :reorder
    end
  end

  resources :vacancies, only: [ :index, :create, :update, :destroy ] do
    member do
      patch :toggle_display
    end
    collection do
      patch :reorder
    end
  end

  resources :call_requests, only: [ :index, :create ] do
    member do
      post :change_state
    end
  end
end
