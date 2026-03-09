# frozen_string_literal: true

module Products
  class CreateContract
    attr_reader :errors

    def initialize(params)
      @name = params[:name].to_s.strip
      @description = params[:description].to_s
      @photos = Array(params[:photos]).select(&:present?)
      @errors = []
    end

    def valid?
      validate_name
      validate_photos
      @errors.empty?
    end

    def to_h
      { name: @name, description: @description, photos: @photos }
    end

    private

    def validate_name
      @errors << "Name is required" if @name.blank?
    end

    def validate_photos
      @errors << "At least one photo is required" if @photos.empty?
    end
  end
end
