# frozen_string_literal: true

module Vacancies
  class IndexService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      contract = Vacancies::IndexContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      vacancies =
        if data[:published_only]
          Vacancy.published.with_attached_photo
        else
          Vacancy.with_attached_photo.order(created_at: :desc)
        end

      serialized = vacancies.map { |v| @serializer.new(v, request: @input[:request]).as_json }
      { success: true, data: serialized }
    end

    private

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
