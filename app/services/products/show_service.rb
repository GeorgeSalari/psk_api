# frozen_string_literal: true

module Products
  class ShowService < BaseService
    def call
      product = Product.find_by(slug: @input[:id])
      return not_found("Product not found") unless product
      return not_found("Product not found") unless product.display

      success(serialize(product))
    end
  end
end
