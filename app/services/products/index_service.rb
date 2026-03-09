# frozen_string_literal: true

module Products
  class IndexService
    def initialize(serializer:, request: nil)
      @serializer = serializer
      @request = request
    end

    def call
      products = Product.with_attached_photos.order(created_at: :desc)
      data = products.map { |p| @serializer.new(p, request: @request).as_json }
      { success: true, data: data }
    end
  end
end
