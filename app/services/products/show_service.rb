# frozen_string_literal: true

module Products
  class ShowService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      product = Product.find_by(slug: @input[:id])
      return not_found("Product not found") unless product
      return not_found("Product not found") unless product.display

      { success: true, data: @serializer.new(product, request: @input[:request]).as_json }
    end

    private

    def not_found(message)
      { success: false, not_found: true, errors: [ message ] }
    end
  end
end
