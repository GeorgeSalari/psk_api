# frozen_string_literal: true

module Products
  class CreateService < BaseService
    def call
      contract = Products::CreateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      product = Product.new(name: data[:name], description: data[:description])
      product.photos.attach(data[:photos])

      if product.save
        product.update(photo_positions: product.photos.map(&:id))
        success(serialize(product.reload))
      else
        failure(product.errors.full_messages)
      end
    end
  end
end
