# frozen_string_literal: true

class CallRequestsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, only: [ :index, :change_state ]

  def create
    handle_result result, success_status: :created
  end

  def index
    handle_result result
  end

  def change_state
    handle_result result
  end

  private

  def result
    service.new(input, serializer: CallRequestSerializer).call
  end

  def service
    "CallRequests::#{action_name.camelize}Service".constantize
  end

  def input
    { resource: CallRequest, id: params[:id], params: call_request_params, request: request }
  end

  def call_request_params
    params.permit(:contact_name, :phone, :comment, :filter)
  end
end
