# frozen_string_literal: true

class Vacancy < ApplicationRecord
  include Displayable

  has_one_attached :photo

  validates :name, presence: true
end
