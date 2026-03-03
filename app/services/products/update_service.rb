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
      @product.photo.attach(data[:photo]) if data.key?(:photo)

      if @product.save
        success(@product)
      else
        failure(@product.errors.full_messages)
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
