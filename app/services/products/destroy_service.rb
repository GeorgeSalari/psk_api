# frozen_string_literal: true

module Products
  class DestroyService < BaseService
    def call
      product = Product.find_by(id: @input[:id])
      return not_found("Product not found") unless product

      product.photos.purge if product.photos.attached?
      product.destroy!
      success
    rescue ActiveRecord::RecordNotDestroyed => e
      failure([ e.message ])
    end
  end
end
