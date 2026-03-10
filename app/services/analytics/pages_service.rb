# frozen_string_literal: true

module Analytics
  class PagesService < BaseService
    def call
      contract = Analytics::PeriodContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      rows = Ahoy::Event
        .where("time >= ?", contract.start_date)
        .where(name: "$view")
        .group("properties->>'page'")
        .order(Arel.sql("count(*) DESC"))
        .limit(20)
        .count

      success(rows.map { |page, count| { page: page, views: count } })
    end
  end
end
