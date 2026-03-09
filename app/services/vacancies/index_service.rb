# frozen_string_literal: true

module Vacancies
  class IndexService
    def initialize(serializer:, request: nil, published_only: false)
      @serializer = serializer
      @request = request
      @published_only = published_only
    end

    def call
      vacancies = if @published_only
                    Vacancy.published.with_attached_photo
                  else
                    Vacancy.with_attached_photo.order(created_at: :desc)
                  end
      data = vacancies.map { |v| @serializer.new(v, request: @request).as_json }
      { success: true, data: data }
    end
  end
end
