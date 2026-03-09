# frozen_string_literal: true

class Certificate < ApplicationRecord
  include Displayable

  has_one_attached :photo

  validates :name, presence: true
end
