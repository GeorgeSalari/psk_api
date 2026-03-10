# frozen_string_literal: true

class AdminSessionsController < ApplicationController
  def create
    handle_result result
  end

  private

  def result
    service.new(input).call
  end

  def service
    AdminAuth::SignInService
  end

  def input
    { params: params.permit(:email, :password), request: request }
  end
end
