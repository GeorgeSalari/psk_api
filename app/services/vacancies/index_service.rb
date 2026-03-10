# frozen_string_literal: true

module Vacancies
  class IndexService < BaseService
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

      success(serialize_collection(vacancies))
    end
  end
end
