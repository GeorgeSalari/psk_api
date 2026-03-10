# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 8.1"
gem "pg", "~> 1.6"
gem "puma", ">= 5.0"
gem "redis", "~> 5.0"
gem "sidekiq", "~> 8.0"
gem "rack-cors"
gem "rack-attack"
gem "bcrypt", "~> 3.1"
gem "jwt", "~> 2.9"
gem "ahoy_matey"
gem "aws-sdk-s3", require: false
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end
