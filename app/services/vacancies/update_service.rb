# frozen_string_literal: true

module Vacancies
  class UpdateService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      vacancy = Vacancy.find_by(id: @input[:id])
      return not_found("Vacancy not found") unless vacancy

      contract = Vacancies::UpdateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      vacancy.name = data[:name] if data.key?(:name)
      vacancy.description = data[:description] if data.key?(:description)
      vacancy.photo.attach(data[:photo]) if data.key?(:photo)

      if vacancy.save
        { success: true, data: @serializer.new(vacancy, request: @input[:request]).as_json }
      else
        failure(vacancy.errors.full_messages)
      end
    end

    private

    def not_found(message)
      { success: false, not_found: true, errors: [ message ] }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
