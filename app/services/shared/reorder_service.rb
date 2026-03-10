# frozen_string_literal: true

module Shared
  class ReorderService
    def initialize(input, serializer: nil)
      @input = input
    end

    def call
      ids = Array(@input[:ids]).map(&:to_i)
      return { success: false, errors: [ "IDs are required" ] } if ids.empty?

      ActiveRecord::Base.transaction do
        ids.each_with_index do |id, idx|
          @input[:resource].where(id: id).update_all(position: idx + 1)
        end
      end

      { success: true }
    rescue ActiveRecord::ActiveRecordError => e
      { success: false, errors: [ e.message ] }
    end
  end
end
