# frozen_string_literal: true

module Products
  class CreateService
    def initialize(params, serializer:, request: nil)
      @params = params
      @serializer = serializer
      @request = request
    end

    def call
      contract = Products::CreateContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      product = Product.new(name: data[:name], description: data[:description])
      product.photos.attach(data[:photos])

      if product.save
        product.update(photo_positions: product.photos.map(&:id))
        success(product.reload)
      else
        failure(product.errors.full_messages)
      end
    end

    private

    def success(product)
      { success: true, data: @serializer.new(product, request: @request).as_json }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
