# frozen_string_literal: true

module Certificates
  class IndexService
    def initialize(serializer:, request: nil, published_only: false)
      @serializer = serializer
      @request = request
      @published_only = published_only
    end

    def call
      certificates = if @published_only
                       Certificate.published.with_attached_photo
                     else
                       Certificate.with_attached_photo.order(created_at: :desc)
                     end
      data = certificates.map { |c| @serializer.new(c, request: @request).as_json }
      { success: true, data: data }
    end
  end
end
