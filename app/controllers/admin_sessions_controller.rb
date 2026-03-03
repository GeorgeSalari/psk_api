# frozen_string_literal: true

class AdminSessionsController < ApplicationController
  def create
    result = AdminAuth::SignInService.new(sign_in_params).call

    if result[:success]
      render json: { token: result[:token] }, status: :ok
    else
      render json: { error: result[:errors].first }, status: :unauthorized
    end
  end

  private

  def sign_in_params
    params.permit(:email, :password)
  end
end
