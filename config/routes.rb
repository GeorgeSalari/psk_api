# frozen_string_literal: true

Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root API info
  root "health#index"
  get "api", to: "health#index"
end
