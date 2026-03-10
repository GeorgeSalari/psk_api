# frozen_string_literal: true

module CallRequests
  class ChangeStateService < BaseService
    def call
      call_request = CallRequest.find_by(id: @input[:id])
      return not_found("Call request not found") unless call_request

      call_request.called = !call_request.called

      if call_request.save
        success(serialize(call_request))
      else
        failure(call_request.errors.full_messages)
      end
    end
  end
end
