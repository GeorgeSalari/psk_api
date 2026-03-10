# frozen_string_literal: true

class CallRequestEmailJob < ApplicationJob
  queue_as :default

  def perform(call_request_id)
    CallRequests::SendEmailService.new(call_request_id).call
  end
end
