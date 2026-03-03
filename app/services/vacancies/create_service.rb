# frozen_string_literal: true

module Vacancies
  class CreateService
    def initialize(params, serializer:, request: nil)
      @params = params
      @serializer = serializer
      @request = request
    end

    def call
      contract = Vacancies::CreateContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      vacancy = Vacancy.new(name: data[:name], description: data[:description])
      vacancy.photo.attach(data[:photo])

      if vacancy.save
        success(vacancy)
      else
        failure(vacancy.errors.full_messages)
      end
    end

    private

    def success(vacancy)
      { success: true, data: @serializer.new(vacancy, request: @request).as_json }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
