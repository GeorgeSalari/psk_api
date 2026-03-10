# frozen_string_literal: true

module CallRequests
  class CreateContract
    RUSSIAN_PHONE_REGEX = /\A(\+7|8)\d{10}\z/

    attr_reader :errors

    def initialize(params)
      @contact_name = params[:contact_name].to_s.strip
      @phone = normalize_phone(params[:phone].to_s.strip)
      @comment = params[:comment].to_s.strip.presence
      @errors = []
    end

    def valid?
      validate_contact_name
      validate_phone
      @errors.empty?
    end

    def to_h
      { contact_name: @contact_name, phone: @phone, comment: @comment }
    end

    private

    def normalize_phone(raw)
      raw.gsub(/[\s\-()]+/, "")
    end

    def validate_contact_name
      @errors << "Имя обязательно для заполнения" if @contact_name.empty?
    end

    def validate_phone
      if @phone.empty?
        @errors << "Телефон обязателен для заполнения"
      elsif !RUSSIAN_PHONE_REGEX.match?(@phone)
        @errors << "Введите корректный российский номер телефона"
      end
    end
  end
end
