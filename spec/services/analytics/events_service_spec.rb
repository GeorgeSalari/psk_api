# frozen_string_literal: true

require "rails_helper"

RSpec.describe Analytics::EventsService do
  let(:request) { fake_request }

  before do
    visit = create(:ahoy_visit, started_at: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "product_click", time: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "product_click", time: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "form_submit", time: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "$view", time: 1.hour.ago)
  end

  describe "#call" do
    let(:input) { { params: { period: "today" }, request: request } }

    it "returns events excluding $view" do
      result = described_class.new(input).call
      expect(result[:success]).to be true
      names = result[:data].map { |e| e[:name] }
      expect(names).not_to include("$view")
      expect(names).to include("product_click")
    end

    it "counts correctly" do
      result = described_class.new(input).call
      click = result[:data].find { |e| e[:name] == "product_click" }
      expect(click[:count]).to eq(2)
    end
  end
end
