# frozen_string_literal: true

module Certificates
  class UpdateContract
    attr_reader :errors

    def initialize(params)
      @name = params[:name]&.strip
      @photo = params[:photo]
      @errors = []
    end

    def valid?
      validate_name if @name.present? || @name == ""
      @errors.empty?
    end

    def to_h
      result = {}
      result[:name] = @name if @name.present?
      result[:photo] = @photo if @photo.present?
      result
    end

    private

    def validate_name
      @errors << "Name cannot be blank" if @name.blank?
    end
  end
end
