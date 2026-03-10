# frozen_string_literal: true

module CallRequests
  class ChangeStateService
    def initialize(call_request, serializer:, request: nil)
      @call_request = call_request
      @serializer = serializer
      @request = request
    end

    def call
      @call_request.called = !@call_request.called

      if @call_request.save
        { success: true, data: @serializer.new(@call_request, request: @request).as_json }
      else
        { success: false, errors: @call_request.errors.full_messages }
      end
    end
  end
end
