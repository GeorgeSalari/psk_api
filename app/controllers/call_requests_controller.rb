# frozen_string_literal: true

class CallRequestsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, only: [ :index, :change_state ]

  def create
    result = CallRequests::CreateService.new(
      call_request_params,
      serializer: CallRequestSerializer,
      request: request
    ).call
    handle_result(result, success_status: :created)
  end

  def index
    result = CallRequests::IndexService.new(
      { filter: params[:filter] },
      serializer: CallRequestSerializer,
      request: request
    ).call
    handle_result(result)
  end

  def change_state
    result = CallRequests::ChangeStateService.new(
      params[:id],
      serializer: CallRequestSerializer,
      request: request
    ).call
    handle_result(result)
  end

  private

  def call_request_params
    params.permit(:contact_name, :phone, :comment)
  end
end
