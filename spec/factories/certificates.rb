# frozen_string_literal: true

FactoryBot.define do
  factory :certificate do
    name { Faker::Commerce.product_name }
    display { false }
    position { 0 }
  end
end
