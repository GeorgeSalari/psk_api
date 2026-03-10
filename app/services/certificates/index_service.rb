# frozen_string_literal: true

module Certificates
  class IndexService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      contract = Certificates::IndexContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      certificates =
        if data[:published_only]
          Certificate.published.with_attached_photo
        else
          Certificate.with_attached_photo.order(created_at: :desc)
        end

      serialized = certificates.map { |c| @serializer.new(c, request: @input[:request]).as_json }
      { success: true, data: serialized }
    end

    private

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
