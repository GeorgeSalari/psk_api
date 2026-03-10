# frozen_string_literal: true

module Vacancies
  class CreateService < BaseService
    def call
      contract = Vacancies::CreateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      vacancy = Vacancy.new(name: data[:name], description: data[:description])
      vacancy.photo.attach(data[:photo])

      if vacancy.save
        success(serialize(vacancy))
      else
        failure(vacancy.errors.full_messages)
      end
    end
  end
end
