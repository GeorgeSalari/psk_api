# frozen_string_literal: true

module Products
  class UpdateService
    def initialize(product, params, serializer:, request: nil)
      @product = product
      @params = params
      @serializer = serializer
      @request = request
    end

    def call
      contract = Products::UpdateContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      @product.name = data[:name] if data.key?(:name)
      @product.description = data[:description] if data.key?(:description)

      remove_photos(data[:remove_photo_ids]) if data.key?(:remove_photo_ids)
      @product.photos.attach(data[:photos]) if data.key?(:photos) && data[:photos].any?

      if @product.save
        update_positions(data[:photo_positions]) if data.key?(:photo_positions)
        success(@product.reload)
      else
        failure(@product.errors.full_messages)
      end
    end

    private

    def remove_photos(ids)
      @product.photos.each do |photo|
        photo.purge if ids.include?(photo.id)
      end
    end

    def update_positions(positions)
      if positions.present?
        parsed = positions.is_a?(String) ? JSON.parse(positions) : Array(positions)
        @product.update(photo_positions: parsed.map(&:to_i))
      else
        @product.update(photo_positions: @product.photos.map(&:id))
      end
    end

    def success(product)
      { success: true, data: @serializer.new(product, request: @request).as_json }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
