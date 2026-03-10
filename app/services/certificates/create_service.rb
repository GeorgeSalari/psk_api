# frozen_string_literal: true

module Certificates
  class CreateService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      contract = Certificates::CreateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      certificate = Certificate.new(name: data[:name])
      certificate.photo.attach(data[:photo])

      if certificate.save
        { success: true, data: @serializer.new(certificate, request: @input[:request]).as_json }
      else
        failure(certificate.errors.full_messages)
      end
    end

    private

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
