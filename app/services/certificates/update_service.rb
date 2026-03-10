# frozen_string_literal: true

module Certificates
  class UpdateService < BaseService
    def call
      certificate = Certificate.find_by(id: @input[:id])
      return not_found("Certificate not found") unless certificate

      contract = Certificates::UpdateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      certificate.name = data[:name] if data.key?(:name)
      certificate.photo.attach(data[:photo]) if data.key?(:photo)

      if certificate.save
        success(serialize(certificate))
      else
        failure(certificate.errors.full_messages)
      end
    end
  end
end
