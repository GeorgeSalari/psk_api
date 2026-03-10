# frozen_string_literal: true

module Shared
  class ToggleDisplayService
    def initialize(model_class, id, serializer:, request: nil)
      @model_class = model_class
      @id = id
      @serializer = serializer
      @request = request
    end

    def call
      record = @model_class.find_by(id: @id)
      return not_found("#{@model_class.name} not found") unless record

      new_display = !record.display

      if new_display
        max_pos = @model_class.published.maximum(:position) || 0
        record.update!(display: true, position: max_pos + 1)
      else
        record.update!(display: false, position: 0)
        reindex_positions(record)
      end

      { success: true, data: @serializer.new(record.reload, request: @request).as_json }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, errors: e.record.errors.full_messages }
    end

    private

    def reindex_positions(record)
      record.class.published.each_with_index do |r, idx|
        r.update_column(:position, idx + 1)
      end
    end

    def not_found(message)
      { success: false, not_found: true, errors: [ message ] }
    end
  end
end
