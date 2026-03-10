# frozen_string_literal: true

module Certificates
  class IndexContract
    attr_reader :errors

    def initialize(params)
      @published = params[:published].to_s.strip
      @errors = []
    end

    def valid?
      @errors.empty?
    end

    def to_h
      { published_only: @published == "true" }
    end
  end
end
