# frozen_string_literal: true

class CallRequestSerializer < BaseSerializer
  def as_json
    {
      id: @record.id,
      contact_name: @record.contact_name,
      phone: @record.phone,
      comment: @record.comment,
      called: @record.called,
      email_sent_at: @record.email_sent_at,
      created_at: @record.created_at
    }
  end
end
