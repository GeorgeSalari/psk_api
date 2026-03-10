# frozen_string_literal: true

module Analytics
  class VisitorsChartService
    def initialize(input, serializer: nil)
      @input = input
    end

    def call
      contract = Analytics::PeriodContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      rows = Ahoy::Visit
        .where("started_at >= ?", contract.start_date)
        .group("DATE(started_at)")
        .select("DATE(started_at) AS day, COUNT(DISTINCT visitor_token) AS visitors")
        .order("day")

      { success: true, data: rows.map { |r| { day: r.day.to_s, visitors: r.visitors } } }
    end

    private

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
