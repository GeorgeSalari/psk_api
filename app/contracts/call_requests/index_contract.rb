# frozen_string_literal: true

module CallRequests
  class IndexContract
    VALID_FILTERS = %w[ pending processed ].freeze

    attr_reader :errors

    def initialize(params)
      @filter = params[:filter].to_s.strip
      @errors = []
    end

    def valid?
      validate_filter
      @errors.empty?
    end

    def to_h
      { filter: @filter.presence || "pending" }
    end

    private

    def validate_filter
      return if @filter.empty?

      @errors << "Invalid filter" unless VALID_FILTERS.include?(@filter)
    end
  end
end
