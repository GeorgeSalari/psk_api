# frozen_string_literal: true

module Certificates
  class DestroyService
    def initialize(input, serializer: nil)
      @input = input
    end

    def call
      certificate = Certificate.find_by(id: @input[:id])
      return not_found("Certificate not found") unless certificate

      certificate.photo.purge if certificate.photo.attached?
      certificate.destroy!
      { success: true }
    rescue ActiveRecord::RecordNotDestroyed => e
      { success: false, errors: [ e.message ] }
    end

    private

    def not_found(message)
      { success: false, not_found: true, errors: [ message ] }
    end
  end
end
