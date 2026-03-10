# frozen_string_literal: true

module Certificates
  class UpdateService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      certificate = Certificate.find_by(id: @input[:id])
      return not_found("Certificate not found") unless certificate

      contract = Certificates::UpdateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      certificate.name = data[:name] if data.key?(:name)
      certificate.photo.attach(data[:photo]) if data.key?(:photo)

      if certificate.save
        { success: true, data: @serializer.new(certificate, request: @input[:request]).as_json }
      else
        failure(certificate.errors.full_messages)
      end
    end

    private

    def not_found(message)
      { success: false, not_found: true, errors: [ message ] }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
