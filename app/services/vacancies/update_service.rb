# frozen_string_literal: true

module Vacancies
  class UpdateService
    def initialize(vacancy, params, serializer:, request: nil)
      @vacancy = vacancy
      @params = params
      @serializer = serializer
      @request = request
    end

    def call
      contract = Vacancies::UpdateContract.new(@params)
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      @vacancy.name = data[:name] if data.key?(:name)
      @vacancy.description = data[:description] if data.key?(:description)
      @vacancy.photo.attach(data[:photo]) if data.key?(:photo)

      if @vacancy.save
        success(@vacancy)
      else
        failure(@vacancy.errors.full_messages)
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
