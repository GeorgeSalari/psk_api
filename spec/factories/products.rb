# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Commerce.unique.product_name }
    description { Faker::Lorem.paragraph }
    display { false }
    position { 0 }
  end
end
