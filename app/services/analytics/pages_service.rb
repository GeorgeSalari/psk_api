# frozen_string_literal: true

module Analytics
  class PagesService
    def initialize(params)
      @params = params
    end

    def call
      contract = Analytics::PeriodContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      rows = Ahoy::Event
        .where("time >= ?", contract.start_date)
        .where(name: "$view")
        .group("properties->>'page'")
        .order(Arel.sql("count(*) DESC"))
        .limit(20)
        .count

      { success: true, data: rows.map { |page, count| { page: page, views: count } } }
    end

    private

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
