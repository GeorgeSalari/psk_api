# frozen_string_literal: true

module Certificates
  class CreateContract
    attr_reader :errors

    def initialize(params)
      @name = params[:name].to_s.strip
      @photo = params[:photo]
      @errors = []
    end

    def valid?
      validate_name
      validate_photo
      @errors.empty?
    end

    def to_h
      { name: @name, photo: @photo }
    end

    private

    def validate_name
      @errors << 'Name is required' if @name.blank?
    end

    def validate_photo
      @errors << 'Photo is required' unless @photo.present?
    end
  end
end
