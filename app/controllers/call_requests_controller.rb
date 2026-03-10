# frozen_string_literal: true

class CallRequestsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, only: [ :index, :change_state ]

  def create
    handle_result CallRequests::CreateService.new(input, serializer: CallRequestSerializer).call, success_status: :created
  end

  def index
    handle_result CallRequests::IndexService.new(input, serializer: CallRequestSerializer).call
  end

  def change_state
    handle_result CallRequests::ChangeStateService.new(input, serializer: CallRequestSerializer).call
  end

  private

  def input
    { resource: CallRequest, id: params[:id], params: call_request_params, request: request }
  end

  def call_request_params
    params.permit(:contact_name, :phone, :comment, :filter)
  end
end
