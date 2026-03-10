# frozen_string_literal: true

module Products
  class IndexService < BaseService
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

      success(serialize_collection(products))
    end
  end
end
