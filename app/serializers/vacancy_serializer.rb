# frozen_string_literal: true

class VacancySerializer < BaseSerializer
  def as_json
    {
      id: @record.id,
      name: @record.name,
      description: @record.description,
      photo_url: blob_url(@record.photo),
      display: @record.display,
      position: @record.position,
      created_at: @record.created_at
    }
  end
end
