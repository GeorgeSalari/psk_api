# frozen_string_literal: true

class CertificatesController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index ]
  before_action :set_certificate, only: [ :update, :destroy ]

  def index
    certificates = Certificate.with_attached_photo.order(created_at: :desc)
    render json: CertificateSerializer.collection(certificates, request: request)
  end

  def create
    result = Certificates::CreateService.new(certificate_params).call

    if result[:success]
      render json: CertificateSerializer.new(result[:certificate], request: request).as_json, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def update
    result = Certificates::UpdateService.new(@certificate, certificate_params).call

    if result[:success]
      render json: CertificateSerializer.new(result[:certificate], request: request).as_json
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
