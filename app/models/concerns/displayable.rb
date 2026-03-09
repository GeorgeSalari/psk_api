# frozen_string_literal: true

module Displayable
  extend ActiveSupport::Concern

  included do
    scope :published, -> { where(display: true).order(position: :asc) }
    scope :hidden, -> { where(display: false).order(created_at: :desc) }
  end
end
