# frozen_string_literal: true

class CallRequest < ApplicationRecord
  validates :contact_name, presence: true
  validates :phone, presence: true

  scope :pending, -> { where(called: false).order(created_at: :desc) }
  scope :processed, -> { where(called: true).order(updated_at: :desc) }
end
