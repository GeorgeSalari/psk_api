# frozen_string_literal: true

module Products
  class UpdateContract
    attr_reader :errors

    def initialize(params)
      @name = params[:name]&.strip
      @description = params[:description]
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
      result[:description] = @description unless @description.nil?
      result[:photo] = @photo if @photo.present?
      result
    end

    private

    def validate_name
      @errors << "Name cannot be blank" if @name.blank?
    end
  end
end
