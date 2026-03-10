# frozen_string_literal: true

module Shared
  class ToggleDisplayService < BaseService
    def call
      model_class = @input[:resource]
      record = model_class.find_by(id: @input[:id])
      return not_found("#{model_class.name} not found") unless record

      new_display = !record.display

      if new_display
        max_pos = model_class.published.maximum(:position) || 0
        record.update!(display: true, position: max_pos + 1)
      else
        record.update!(display: false, position: 0)
        reindex_positions(record)
      end

      success(serialize(record.reload))
    rescue ActiveRecord::RecordInvalid => e
      failure(e.record.errors.full_messages)
    end

    private

    def reindex_positions(record)
      record.class.published.each_with_index do |r, idx|
        r.update_column(:position, idx + 1)
      end
    end
  end
end
