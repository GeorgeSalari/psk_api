# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :photos

  validates :name, presence: true

  def ordered_photo_ids
    (photo_positions.presence || photos.map(&:id)).map(&:to_i)
  end

  def ordered_photos
    id_order = ordered_photo_ids
    photos.sort_by { |p| id_order.index(p.id) || id_order.size }
  end

  private

  def photo_positions
    self[:photo_positions]
  end
end
