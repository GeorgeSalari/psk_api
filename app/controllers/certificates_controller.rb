# frozen_string_literal: true

class CertificatesController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index ]

  def index
    published_only = params[:published] == "true"
    result = Certificates::IndexService.new(
      serializer: CertificateSerializer,
      request: request,
      published_only: published_only
    ).call
    render json: result[:data]
  end

  def create
    result = Certificates::CreateService.new(certificate_params, serializer: CertificateSerializer, request: request).call
    handle_result(result, success_status: :created)
  end

  def update
    result = Certificates::UpdateService.new(params[:id], certificate_params, serializer: CertificateSerializer, request: request).call
    handle_result(result)
  end

  def destroy
    result = Certificates::DestroyService.new(params[:id]).call
    handle_result(result, success_status: :no_content)
  end

  def toggle_display
    result = Shared::ToggleDisplayService.new(Certificate, params[:id], serializer: CertificateSerializer, request: request).call
    handle_result(result)
  end

  def reorder
    result = Shared::ReorderService.new(Certificate, params[:ids]).call
    handle_result(result, success_status: :no_content)
  end

  private

  def certificate_params
    params.permit(:name, :photo)
  end
end
