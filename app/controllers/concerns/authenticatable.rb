# frozen_string_literal: true

module Authenticatable
  extend ActiveSupport::Concern

  private

  def authenticate_admin!
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = JwtService.decode(token) if token

    unless decoded
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    @current_admin = Admin.find_by(id: decoded[:admin_id])
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_admin
  end

  def current_admin
    @current_admin
  end
end
