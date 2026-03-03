# frozen_string_literal: true

module Vacancies
  class DestroyService
    def initialize(vacancy)
      @vacancy = vacancy
    end

    def call
      @vacancy.photo.purge if @vacancy.photo.attached?
      @vacancy.destroy!
      { success: true }
    rescue ActiveRecord::RecordNotDestroyed => e
      { success: false, errors: [ e.message ] }
    end
  end
end
