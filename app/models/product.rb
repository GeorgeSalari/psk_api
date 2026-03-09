# frozen_string_literal: true

class Product < ApplicationRecord
  include Displayable

  has_many_attached :photos

  before_validation :generate_slug, if: -> { name.present? && (slug.blank? || name_changed?) }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def ordered_photo_ids
    (photo_positions.presence || photos.map(&:id)).map(&:to_i)
  end

  def ordered_photos
    id_order = ordered_photo_ids
    photos.sort_by { |p| id_order.index(p.id) || id_order.size }
  end

  private

  CYRILLIC_MAP = {
    "а" => "a", "б" => "b", "в" => "v", "г" => "g", "д" => "d", "е" => "e",
    "ё" => "yo", "ж" => "zh", "з" => "z", "и" => "i", "й" => "y", "к" => "k",
    "л" => "l", "м" => "m", "н" => "n", "о" => "o", "п" => "p", "р" => "r",
    "с" => "s", "т" => "t", "у" => "u", "ф" => "f", "х" => "kh", "ц" => "ts",
    "ч" => "ch", "ш" => "sh", "щ" => "shch", "ъ" => "", "ы" => "y", "ь" => "",
    "э" => "e", "ю" => "yu", "я" => "ya"
  }.freeze

  def generate_slug
    base = transliterate(name)
    self.slug = base
    counter = 2
    while Product.where(slug: slug).where.not(id: id).exists?
      self.slug = "#{base}-#{counter}"
      counter += 1
    end
  end

  def transliterate(text)
    result = text.to_s.downcase.chars.map { |c| CYRILLIC_MAP[c] || c }.join
    result.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-\z/, "").presence || "product"
  end

  def photo_positions
    self[:photo_positions]
  end
end
