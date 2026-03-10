# frozen_string_literal: true

class CertificatesController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index ]

  def index
    handle_result result
  end

  def create
    handle_result result, success_status: :created
  end

  def update
    handle_result result
  end

  def destroy
    handle_result result, success_status: :no_content
  end

  def toggle_display
    handle_result result
  end

  def reorder
    handle_result result, success_status: :no_content
  end

  private

  def result
    service.new(input, serializer: CertificateSerializer).call
  end

  def service
    "Certificates::#{action_name.camelize}Service".constantize
  rescue NameError
    "Shared::#{action_name.camelize}Service".constantize
  end

  def input
    { resource: Certificate, id: params[:id], ids: params[:ids], params: certificate_params, request: request }
  end

  def certificate_params
    params.permit(:name, :photo, :published)
  end
end
