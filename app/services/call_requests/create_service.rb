# frozen_string_literal: true

module CallRequests
  class CreateService < BaseService
    def call
      contract = CallRequests::CreateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      call_request = CallRequest.new(data)

      if call_request.save
        send_notification(call_request.id)
        success(serialize(call_request))
      else
        failure(call_request.errors.full_messages)
      end
    end

    private

    def send_notification(call_request_id)
      CallRequestEmailJob.perform_later(call_request_id)
    rescue StandardError => e
      Rails.logger.warn("Failed to enqueue email job for CallRequest ##{call_request_id}: #{e.message}")
    end
  end
end
