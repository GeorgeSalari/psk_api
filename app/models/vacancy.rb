# frozen_string_literal: true

class Vacancy < ApplicationRecord
  has_one_attached :photo

  validates :name, presence: true
end
