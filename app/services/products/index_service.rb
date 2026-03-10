# frozen_string_literal: true

module Products
  class IndexService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      contract = Products::IndexContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      products =
        if data[:published_only]
          Product.published.with_attached_photos
        else
          Product.with_attached_photos.order(created_at: :desc)
        end

      serialized = products.map { |p| @serializer.new(p, request: @input[:request]).as_json }
      { success: true, data: serialized }
    end

    private

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
