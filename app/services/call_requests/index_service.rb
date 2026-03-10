# frozen_string_literal: true

module CallRequests
  class IndexService
    def initialize(params, serializer:, request: nil)
      @params = params
      @serializer = serializer
      @request = request
    end

    def call
      contract = CallRequests::IndexContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      records = data[:filter] == "processed" ? CallRequest.processed : CallRequest.pending
      serialized = records.map { |r| @serializer.new(r, request: @request).as_json }

      { success: true, data: serialized }
    end

    private

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
