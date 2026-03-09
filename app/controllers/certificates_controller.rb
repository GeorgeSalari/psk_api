# frozen_string_literal: true

class CertificatesController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index ]
  before_action :set_certificate, only: [ :update, :destroy, :toggle_display ]

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

    if result[:success]
      render json: result[:data], status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def update
    result = Certificates::UpdateService.new(@certificate, certificate_params, serializer: CertificateSerializer, request: request).call

    if result[:success]
      render json: result[:data]
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    result = Certificates::DestroyService.new(@certificate).call

    if result[:success]
      head :no_content
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def toggle_display
    result = Shared::ToggleDisplayService.new(@certificate, serializer: CertificateSerializer, request: request).call

    if result[:success]
      render json: result[:data]
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def reorder
    result = Shared::ReorderService.new(Certificate, params[:ids]).call

    if result[:success]
      head :no_content
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_certificate
    @certificate = Certificate.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Certificate not found" }, status: :not_found
  end

  def certificate_params
    params.permit(:name, :photo)
  end
end
