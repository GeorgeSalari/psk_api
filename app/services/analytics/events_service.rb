# frozen_string_literal: true

module Analytics
  class EventsService < BaseService
    def call
      contract = Analytics::PeriodContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      rows = Ahoy::Event
        .where("time >= ?", contract.start_date)
        .where.not(name: "$view")
        .group(:name)
        .order(Arel.sql("count(*) DESC"))
        .limit(20)
        .count

      success(rows.map { |name, count| { name: name, count: count } })
    end
  end
end
