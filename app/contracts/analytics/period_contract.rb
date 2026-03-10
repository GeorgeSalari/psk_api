# frozen_string_literal: true

module Analytics
  class PeriodContract
    VALID_PERIODS = %w[ today week month ].freeze

    attr_reader :errors

    def initialize(params)
      @period = params[:period].to_s.strip
      @errors = []
    end

    def valid?
      validate_period
      @errors.empty?
    end

    def start_date
      case @period
      when "today"
        Time.current.beginning_of_day
      when "week"
        7.days.ago.beginning_of_day
      else
        30.days.ago.beginning_of_day
      end
    end

    private

    def validate_period
      return if @period.empty?

      @errors << "Invalid period" unless VALID_PERIODS.include?(@period)
    end
  end
end
