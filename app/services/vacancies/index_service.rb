# frozen_string_literal: true

module Vacancies
  class IndexService
    def initialize(serializer:, request: nil)
      @serializer = serializer
      @request = request
    end

    def call
      vacancies = Vacancy.with_attached_photo.order(created_at: :desc)
      data = vacancies.map { |v| @serializer.new(v, request: @request).as_json }
      { success: true, data: data }
    end
  end
end
