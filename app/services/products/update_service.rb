# frozen_string_literal: true

module Products
  class UpdateService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      product = Product.find_by(id: @input[:id])
      return not_found("Product not found") unless product

      contract = Products::UpdateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      product.name = data[:name] if data.key?(:name)
      product.description = data[:description] if data.key?(:description)

      remove_photos(product, data[:remove_photo_ids]) if data.key?(:remove_photo_ids)
      product.photos.attach(data[:photos]) if data.key?(:photos) && data[:photos].any?

      if product.save
        update_positions(product, data[:photo_positions]) if data.key?(:photo_positions)
        { success: true, data: @serializer.new(product.reload, request: @input[:request]).as_json }
      else
        failure(product.errors.full_messages)
      end
    end

    private

    def remove_photos(product, ids)
      product.photos.each do |photo|
        photo.purge if ids.include?(photo.id)
      end
    end

    def update_positions(product, positions)
      if positions.present?
        parsed = positions.is_a?(String) ? JSON.parse(positions) : Array(positions)
        product.update(photo_positions: parsed.map(&:to_i))
      else
        product.update(photo_positions: product.photos.map(&:id))
      end
    end

    def not_found(message)
      { success: false, not_found: true, errors: [ message ] }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
