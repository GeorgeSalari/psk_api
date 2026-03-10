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
        CallRequestEmailJob.perform_later(call_request.id)
        success(call_request)
      else
        failure(call_request.errors.full_messages)
      end
    end

    private

    def success(call_request)
      { success: true, data: @serializer.new(call_request, request: @request).as_json }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
