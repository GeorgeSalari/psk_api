# frozen_string_literal: true

module Shared
  class ToggleDisplayService
    def initialize(record, serializer:, request: nil)
      @record = record
      @serializer = serializer
      @request = request
    end

    def call
      new_display = !@record.display

      if new_display
        max_pos = @record.class.published.maximum(:position) || 0
        @record.update!(display: true, position: max_pos + 1)
      else
        @record.update!(display: false, position: 0)
        reindex_positions
      end

      { success: true, data: @serializer.new(@record.reload, request: @request).as_json }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, errors: e.record.errors.full_messages }
    end

    private

    def reindex_positions
      @record.class.published.each_with_index do |r, idx|
        r.update_column(:position, idx + 1)
      end
    end
  end
end
