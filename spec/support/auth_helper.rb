# frozen_string_literal: true

module AuthHelper
  def auth_headers(admin)
    token = JwtService.encode({ admin_id: admin.id, email: admin.email })
    { "Authorization" => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
