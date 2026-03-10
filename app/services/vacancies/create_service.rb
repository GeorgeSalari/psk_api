# frozen_string_literal: true

module Vacancies
  class CreateService
    def initialize(input, serializer: nil)
      @input = input
      @serializer = serializer
    end

    def call
      contract = Vacancies::CreateContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      vacancy = Vacancy.new(name: data[:name], description: data[:description])
      vacancy.photo.attach(data[:photo])

      if vacancy.save
        { success: true, data: @serializer.new(vacancy, request: @input[:request]).as_json }
      else
        failure(vacancy.errors.full_messages)
      end
    end

    private

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
