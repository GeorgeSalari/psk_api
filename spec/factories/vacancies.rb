# frozen_string_literal: true

FactoryBot.define do
  factory :vacancy do
    name { Faker::Job.unique.title }
    description { Faker::Lorem.paragraph }
    display { false }
    position { 0 }
  end
end
