# frozen_string_literal: true

class AdminSessionsController < ApplicationController
  def create
    handle_result AdminAuth::SignInService.new(input).call
  end

  private

  def input
    { params: params.permit(:email, :password), request: request }
  end
end
