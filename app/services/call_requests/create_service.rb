# frozen_string_literal: true

module CallRequests
  class CreateService
    def initialize(params, serializer:, request: nil)
      @params = params
      @serializer = serializer
      @request = request
    end

    def call
      contract = CallRequests::CreateContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      call_request = CallRequest.new(data)

      if call_request.save
        send_notification(call_request.id)
        success(call_request)
      else
        failure(call_request.errors.full_messages)
      end
    end

    private

    def send_notification(call_request_id)
      CallRequests::SendEmailService.new(call_request_id).call
    rescue StandardError => e
      Rails.logger.error("Failed to send call request email ##{call_request_id}: #{e.message}")
    end

    def success(call_request)
      { success: true, data: @serializer.new(call_request, request: @request).as_json }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
