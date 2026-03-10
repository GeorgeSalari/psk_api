# frozen_string_literal: true

class BaseSerializer
  def initialize(record, request: nil)
    @record = record
    @request = request
  end

  def self.collection(records, request: nil)
    records.map { |r| new(r, request: request).as_json }
  end

  private

  def blob_url(attachment)
    return nil unless attachment.attached?
    build_blob_url(attachment)
  end

  def build_blob_url(blob_or_attachment)
    if @request
      Rails.application.routes.url_helpers.rails_blob_url(blob_or_attachment, host: host_with_port)
    else
      Rails.application.routes.url_helpers.rails_blob_path(blob_or_attachment, only_path: true)
    end
  end

  def host_with_port
    "#{@request.protocol}#{@request.host_with_port}"
  end
end
