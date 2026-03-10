# frozen_string_literal: true

class Rack::Attack
  # Use Rails cache store (memory in dev, can be Redis in prod)
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Throttle rules ###

  # General API: 300 requests per 5 minutes per IP
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets", "/up")
  end

  # Contact form: 5 submissions per 15 minutes per IP
  throttle("call_requests/ip", limit: 5, period: 15.minutes) do |req|
    req.ip if req.path == "/call_requests" && req.post?
  end

  # Admin sign-in: 5 attempts per minute per IP (brute force protection)
  throttle("admin_sign_in/ip", limit: 5, period: 1.minute) do |req|
    req.ip if req.path == "/admin/sign_in" && req.post?
  end

  # Admin sign-in: 10 attempts per 15 minutes per email (account-level protection)
  throttle("admin_sign_in/email", limit: 10, period: 15.minutes) do |req|
    if req.path == "/admin/sign_in" && req.post?
      begin
        body = JSON.parse(req.body.read)
        req.body.rewind
        body["email"].to_s.downcase.strip.presence
      rescue StandardError
        nil
      end
    end
  end

  ### Custom response ###

  self.throttled_responder = lambda do |_env|
    [
      429,
      { "Content-Type" => "application/json" },
      [ { error: "Слишком много запросов. Попробуйте позже." }.to_json ]
    ]
  end
end
