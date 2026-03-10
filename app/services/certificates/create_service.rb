# frozen_string_literal: true

module Certificates
  class CreateService < BaseService
    def call
      contract = Certificates::CreateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      certificate = Certificate.new(name: data[:name])
      certificate.photo.attach(data[:photo])

      if certificate.save
        success(serialize(certificate))
      else
        failure(certificate.errors.full_messages)
      end
    end
  end
end
