# frozen_string_literal: true

module CallRequests
  class IndexService < BaseService
    def call
      contract = CallRequests::IndexContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      records = data[:filter] == "processed" ? CallRequest.processed : CallRequest.pending

      success(serialize_collection(records))
    end
  end
end
