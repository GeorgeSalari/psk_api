# frozen_string_literal: true

class CertificatesController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index ]

  def index
    handle_result Certificates::IndexService.new(input, serializer: CertificateSerializer).call
  end

  def create
    handle_result Certificates::CreateService.new(input, serializer: CertificateSerializer).call, success_status: :created
  end

  def update
    handle_result Certificates::UpdateService.new(input, serializer: CertificateSerializer).call
  end

  def destroy
    handle_result Certificates::DestroyService.new(input).call, success_status: :no_content
  end

  def toggle_display
    handle_result Shared::ToggleDisplayService.new(input, serializer: CertificateSerializer).call
  end

  def reorder
    handle_result Shared::ReorderService.new(input).call, success_status: :no_content
  end

  private

  def input
    { resource: Certificate, id: params[:id], ids: params[:ids], params: certificate_params, request: request }
  end

  def certificate_params
    params.permit(:name, :photo, :published)
  end
end
