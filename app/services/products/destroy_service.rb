# frozen_string_literal: true

module Products
  class DestroyService
    def initialize(product)
      @product = product
    end

    def call
      @product.photo.purge if @product.photo.attached?
      @product.destroy!
      { success: true }
    rescue ActiveRecord::RecordNotDestroyed => e
      { success: false, errors: [ e.message ] }
    end
  end
end
