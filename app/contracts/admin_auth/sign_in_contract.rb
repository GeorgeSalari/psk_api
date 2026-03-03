# frozen_string_literal: true

module AdminAuth
  class SignInContract
    attr_reader :errors

    def initialize(params)
      @email = params[:email].to_s.strip
      @password = params[:password].to_s
      @errors = []
    end

    def valid?
      validate_email
      validate_password
      @errors.empty?
    end

    def to_h
      { email: @email, password: @password }
    end

    private

    def validate_email
      @errors << 'Email is required' if @email.blank?
    end

    def validate_password
      @errors << 'Password is required' if @password.blank?
    end
  end
end
