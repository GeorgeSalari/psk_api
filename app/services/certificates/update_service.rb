# frozen_string_literal: true

module Certificates
  class UpdateService
    def initialize(certificate, params, serializer:, request: nil)
      @certificate = certificate
      @params = params
      @serializer = serializer
      @request = request
    end

    def call
      contract = Certificates::UpdateContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      @certificate.name = data[:name] if data.key?(:name)
      @certificate.photo.attach(data[:photo]) if data.key?(:photo)

      if @certificate.save
        success(@certificate)
      else
        failure(@certificate.errors.full_messages)
      end
    end

    private

    def success(certificate)
      { success: true, data: @serializer.new(certificate, request: @request).as_json }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
