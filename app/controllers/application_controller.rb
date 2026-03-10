# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def handle_result(result, success_status: :ok)
    unless result[:success]
      status = if result[:not_found]
        :not_found
      elsif result[:unauthorized]
        :unauthorized
      else
        :unprocessable_entity
      end
      render json: { errors: result[:errors] }, status: status
      return
    end

    if success_status == :no_content
      head :no_content
    else
      render json: result[:data], status: success_status
    end
  end
end
