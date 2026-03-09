# frozen_string_literal: true

class AddSlugToProducts < ActiveRecord::Migration[8.1]
  def up
    add_column :products, :slug, :string

    Product.reset_column_information
    Product.find_each do |product|
      base = transliterate(product.name)
      slug = base
      counter = 2
      while Product.where(slug: slug).where.not(id: product.id).exists?
        slug = "#{base}-#{counter}"
        counter += 1
      end
      product.update_column(:slug, slug)
    end

    change_column_null :products, :slug, false
    add_index :products, :slug, unique: true
  end

  def down
    remove_index :products, :slug
    remove_column :products, :slug
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

  def transliterate(text)
    result = text.to_s.downcase.chars.map { |c| CYRILLIC_MAP[c] || c }.join
    result.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-\z/, "").presence || "product"
  end
end
