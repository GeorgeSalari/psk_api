# frozen_string_literal: true

module Products
  class ShowService
    def initialize(product, serializer:, request: nil)
      @product = product
      @serializer = serializer
      @request = request
    end

    def call
      { success: true, data: @serializer.new(@product, request: @request).as_json }
    end
  end
end
