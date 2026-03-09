# frozen_string_literal: true

module Products
  class IndexService
    def initialize(serializer:, request: nil, published_only: false)
      @serializer = serializer
      @request = request
      @published_only = published_only
    end

    def call
      products = if @published_only
                   Product.published.with_attached_photos
                 else
                   Product.with_attached_photos.order(created_at: :desc)
                 end
      data = products.map { |p| @serializer.new(p, request: @request).as_json }
      { success: true, data: data }
    end
  end
end
