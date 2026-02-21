# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 8.1"
gem "pg", "~> 1.6"
gem "puma", ">= 5.0"
gem "redis", "~> 5.0"
gem "sidekiq", "~> 8.0"
gem "rack-cors"
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end
