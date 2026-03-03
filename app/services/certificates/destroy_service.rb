# frozen_string_literal: true

module Certificates
  class DestroyService
    def initialize(certificate)
      @certificate = certificate
    end

    def call
      @certificate.photo.purge if @certificate.photo.attached?
      @certificate.destroy!
      { success: true }
    rescue ActiveRecord::RecordNotDestroyed => e
      { success: false, errors: [e.message] }
    end
  end
end
