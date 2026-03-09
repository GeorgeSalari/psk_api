# frozen_string_literal: true

class VacancySerializer
  def initialize(vacancy, request: nil)
    @vacancy = vacancy
    @request = request
  end

  def as_json
    {
      id: @vacancy.id,
      name: @vacancy.name,
      description: @vacancy.description,
      photo_url: photo_url,
      display: @vacancy.display,
      position: @vacancy.position,
      created_at: @vacancy.created_at
    }
  end

  def self.collection(vacancies, request: nil)
    vacancies.map { |v| new(v, request: request).as_json }
  end

  private

  def photo_url
    return nil unless @vacancy.photo.attached?

    if @request
      Rails.application.routes.url_helpers.rails_blob_url(@vacancy.photo, host: host_with_port)
    else
      Rails.application.routes.url_helpers.rails_blob_path(@vacancy.photo, only_path: true)
    end
  end

  def host_with_port
    "#{@request.protocol}#{@request.host_with_port}"
  end
end
