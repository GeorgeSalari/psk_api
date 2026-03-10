# frozen_string_literal: true

module Vacancies
  class UpdateService < BaseService
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
        success(serialize(vacancy))
      else
        failure(vacancy.errors.full_messages)
      end
    end
  end
end
