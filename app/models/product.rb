# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :photo

  validates :name, presence: true
end
