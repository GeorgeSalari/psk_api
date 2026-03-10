# frozen_string_literal: true

class ProductSerializer < BaseSerializer
  def as_json
    {
      id: @record.id,
      slug: @record.slug,
      name: @record.name,
      description: @record.description,
      photo_urls: photo_urls,
      photo_ids: @record.ordered_photo_ids,
      display: @record.display,
      position: @record.position,
      created_at: @record.created_at
    }
  end

  private

  def photo_urls
    return [] unless @record.photos.attached?

    @record.ordered_photos.map { |photo| build_blob_url(photo) }
  end
end
