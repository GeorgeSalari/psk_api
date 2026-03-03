# frozen_string_literal: true

module Certificates
  class IndexService
    def initialize(serializer:, request: nil)
      @serializer = serializer
      @request = request
    end

    def call
      certificates = Certificate.with_attached_photo.order(created_at: :desc)
      data = certificates.map { |c| @serializer.new(c, request: @request).as_json }
      { success: true, data: data }
    end
  end
end
