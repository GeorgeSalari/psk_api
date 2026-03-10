# frozen_string_literal: true

FactoryBot.define do
  factory :ahoy_event, class: "Ahoy::Event" do
    association :visit, factory: :ahoy_visit
    name { "$view" }
    properties { { "page" => "/" } }
    time { Time.current }
  end
end
