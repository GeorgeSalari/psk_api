# frozen_string_literal: true

class ProductSerializer
  def initialize(product, request: nil)
    @product = product
    @request = request
  end

  def as_json
    {
      id: @product.id,
      name: @product.name,
      description: @product.description,
      photo_url: photo_url,
      created_at: @product.created_at
    }
  end

  def self.collection(products, request: nil)
    products.map { |p| new(p, request: request).as_json }
  end

  private

  def photo_url
    return nil unless @product.photo.attached?

    if @request
      Rails.application.routes.url_helpers.rails_blob_url(@product.photo, host: host_with_port)
    else
      Rails.application.routes.url_helpers.rails_blob_path(@product.photo, only_path: true)
    end
  end

  def host_with_port
    "#{@request.protocol}#{@request.host_with_port}"
  end
end
