# frozen_string_literal: true

module CallRequests
  class ChangeStateService
    def initialize(id, serializer:, request: nil)
      @id = id
      @serializer = serializer
      @request = request
    end

    def call
      call_request = CallRequest.find_by(id: @id)
      return not_found("Call request not found") unless call_request

      call_request.called = !call_request.called

      if call_request.save
        { success: true, data: @serializer.new(call_request, request: @request).as_json }
      else
        { success: false, errors: call_request.errors.full_messages }
      end
    end

    private

    def not_found(message)
      { success: false, not_found: true, errors: [ message ] }
    end
  end
end
