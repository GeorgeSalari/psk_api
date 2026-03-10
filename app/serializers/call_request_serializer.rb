# frozen_string_literal: true

class CallRequestSerializer
  def initialize(call_request, request: nil)
    @call_request = call_request
    @request = request
  end

  def as_json
    {
      id: @call_request.id,
      contact_name: @call_request.contact_name,
      phone: @call_request.phone,
      comment: @call_request.comment,
      called: @call_request.called,
      email_sent_at: @call_request.email_sent_at,
      created_at: @call_request.created_at
    }
  end
end
