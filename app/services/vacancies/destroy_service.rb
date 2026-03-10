# frozen_string_literal: true

module Vacancies
  class DestroyService < BaseService
    def call
      vacancy = Vacancy.find_by(id: @input[:id])
      return not_found("Vacancy not found") unless vacancy

      vacancy.photo.purge if vacancy.photo.attached?
      vacancy.destroy!
      success
    rescue ActiveRecord::RecordNotDestroyed => e
      failure([ e.message ])
    end
  end
end
