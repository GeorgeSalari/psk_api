# frozen_string_literal: true

class CertificateSerializer
  def initialize(certificate, request: nil)
    @certificate = certificate
    @request = request
  end

  def as_json
    {
      id: @certificate.id,
      name: @certificate.name,
      photo_url: photo_url,
      created_at: @certificate.created_at
    }
  end

  def self.collection(certificates, request: nil)
    certificates.map { |c| new(c, request: request).as_json }
  end

  private

  def photo_url
    return nil unless @certificate.photo.attached?

    if @request
      Rails.application.routes.url_helpers.rails_blob_url(@certificate.photo, host: host_with_port)
    else
      Rails.application.routes.url_helpers.rails_blob_path(@certificate.photo, only_path: true)
    end
  end

  def host_with_port
    "#{@request.protocol}#{@request.host_with_port}"
  end
end
