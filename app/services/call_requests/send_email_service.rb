# frozen_string_literal: true

module CallRequests
  class SendEmailService
    def initialize(call_request_id)
      @call_request_id = call_request_id
    end

    def call
      call_request = CallRequest.find(@call_request_id)
      CallRequestMailer.notification(call_request).deliver_now
      call_request.update!(email_sent_at: Time.current)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("CallRequest ##{@call_request_id} not found: #{e.message}")
    rescue StandardError => e
      Rails.logger.error("Failed to send email for CallRequest ##{@call_request_id}: #{e.message}")
      raise
    end
  end
end
