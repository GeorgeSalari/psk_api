# frozen_string_literal: true

module Analytics
  class OverviewService < BaseService
    def call
      contract = Analytics::PeriodContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      start = contract.start_date

      success({
        unique_visitors: Ahoy::Visit.where("started_at >= ?", start).distinct.count(:visitor_token),
        total_views: Ahoy::Event.where("time >= ?", start).where(name: "$view").count,
        total_events: Ahoy::Event.where("time >= ?", start).where.not(name: "$view").count
      })
    end
  end
end
