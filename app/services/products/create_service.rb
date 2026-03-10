# frozen_string_literal: true

module Products
  class CreateService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      contract = Products::CreateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      product = Product.new(name: data[:name], description: data[:description])
      product.photos.attach(data[:photos])

      if product.save
        product.update(photo_positions: product.photos.map(&:id))
        { success: true, data: @serializer.new(product.reload, request: @input[:request]).as_json }
      else
        failure(product.errors.full_messages)
      end
    end

    private

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
