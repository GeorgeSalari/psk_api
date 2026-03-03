# frozen_string_literal: true

Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root API info
  root "health#index"
  get "api", to: "health#index"

  scope :admin do
    post "sign_in", to: "admin_sessions#create"
  end

  resources :certificates, only: [ :index, :create, :update, :destroy ]
  resources :products, only: [ :index, :show, :create, :update, :destroy ]
end
