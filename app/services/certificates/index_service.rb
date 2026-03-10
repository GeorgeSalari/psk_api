# frozen_string_literal: true

module Certificates
  class IndexService < BaseService
    def call
      contract = Certificates::IndexContract.new(@input[:params])
      return failure(contract.errors) unless contract.valid?

      data = contract.to_h
      certificates =
        if data[:published_only]
          Certificate.published.with_attached_photo
        else
          Certificate.with_attached_photo.order(created_at: :desc)
        end

      success(serialize_collection(certificates))
    end
  end
end
