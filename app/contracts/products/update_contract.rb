# frozen_string_literal: true

module Products
  class UpdateContract
    attr_reader :errors

    def initialize(params)
      @name = params[:name]&.strip
      @description = params[:description]
      @photos = params[:photos] ? Array(params[:photos]).select(&:present?) : nil
      @remove_photo_ids = params[:remove_photo_ids] ? Array(params[:remove_photo_ids]).map(&:to_i) : nil
      @photo_positions = params[:photo_positions]
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
      result[:photos] = @photos if @photos
      result[:remove_photo_ids] = @remove_photo_ids if @remove_photo_ids
      result[:photo_positions] = @photo_positions if @photo_positions
      result
    end

    private

    def validate_name
      @errors << "Name cannot be blank" if @name.blank?
    end
  end
end
