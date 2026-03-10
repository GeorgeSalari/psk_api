# frozen_string_literal: true

module Products
  class DestroyService
    def initialize(input, serializer: nil)
      @input = input
    end

    def call
      product = Product.find_by(id: @input[:id])
      return not_found("Product not found") unless product

      product.photos.purge if product.photos.attached?
      product.destroy!
      { success: true }
    rescue ActiveRecord::RecordNotDestroyed => e
      { success: false, errors: [ e.message ] }
    end

    private

    def not_found(message)
      { success: false, not_found: true, errors: [ message ] }
    end
  end
end
