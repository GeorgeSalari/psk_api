# frozen_string_literal: true

class Ahoy::Store < Ahoy::DatabaseStore
end

Ahoy.api = true
Ahoy.server_side_visits = :when_needed
Ahoy.cookies = :none
Ahoy.mask_ips = true
Ahoy.track_bots = false
Ahoy.geocode = false
