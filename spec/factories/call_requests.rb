# frozen_string_literal: true

FactoryBot.define do
  factory :call_request do
    contact_name { Faker::Name.name }
    phone { "+79181234567" }
    comment { Faker::Lorem.sentence }
    called { false }
  end
end
