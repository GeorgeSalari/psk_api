# frozen_string_literal: true

module Shared
  class ReorderService
    def initialize(model_class, ids)
      @model_class = model_class
      @ids = Array(ids).map(&:to_i)
    end

    def call
      return { success: false, errors: [ "IDs are required" ] } if @ids.empty?

      ActiveRecord::Base.transaction do
        @ids.each_with_index do |id, idx|
          @model_class.where(id: id).update_all(position: idx + 1)
        end
      end

      { success: true }
    rescue ActiveRecord::ActiveRecordError => e
      { success: false, errors: [ e.message ] }
    end
  end
end
