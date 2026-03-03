# frozen_string_literal: true

module Certificates
  class CreateService
    def initialize(params)
      @params = params
    end

    def call
      contract = Certificates::CreateContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      certificate = Certificate.new(name: data[:name])
      certificate.photo.attach(data[:photo])

      if certificate.save
        success(certificate)
      else
        failure(certificate.errors.full_messages)
      end
    end

    private

    def success(certificate)
      { success: true, certificate: certificate }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
