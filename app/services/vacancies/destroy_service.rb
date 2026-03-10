# frozen_string_literal: true

module Vacancies
  class DestroyService
    def initialize(id)
      @id = id
    end

    def call
      vacancy = Vacancy.find_by(id: @id)
      return not_found("Vacancy not found") unless vacancy

      vacancy.photo.purge if vacancy.photo.attached?
      vacancy.destroy!
      { success: true }
    rescue ActiveRecord::RecordNotDestroyed => e
      { success: false, errors: [ e.message ] }
    end

    private

    def not_found(message)
      { success: false, not_found: true, errors: [ message ] }
    end
  end
end
