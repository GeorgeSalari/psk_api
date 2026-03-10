# frozen_string_literal: true

class CallRequestsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, only: [ :index, :change_state ]
  before_action :set_call_request, only: [ :change_state ]

  def create
    result = CallRequests::CreateService.new(
      call_request_params,
      serializer: CallRequestSerializer,
      request: request
    ).call

    if result[:success]
      render json: result[:data], status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def index
    result = CallRequests::IndexService.new(
      { filter: params[:filter] },
      serializer: CallRequestSerializer,
      request: request
    ).call

    if result[:success]
      render json: result[:data]
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def change_state
    result = CallRequests::ChangeStateService.new(
      @call_request,
      serializer: CallRequestSerializer,
      request: request
    ).call

    if result[:success]
      render json: result[:data]
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_call_request
    @call_request = CallRequest.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Call request not found" }, status: :not_found
  end

  def call_request_params
    params.permit(:contact_name, :phone, :comment)
  end
end
