# frozen_string_literal: true

module Certificates
  class DestroyService < BaseService
    def call
      certificate = Certificate.find_by(id: @input[:id])
      return not_found("Certificate not found") unless certificate

      certificate.photo.purge if certificate.photo.attached?
      certificate.destroy!
      success
    rescue ActiveRecord::RecordNotDestroyed => e
      failure([ e.message ])
    end
  end
end
