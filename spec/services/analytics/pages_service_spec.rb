# frozen_string_literal: true

require "rails_helper"

RSpec.describe Analytics::PagesService do
  let(:request) { fake_request }

  before do
    visit = create(:ahoy_visit, started_at: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "$view", properties: { "page" => "/" }, time: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "$view", properties: { "page" => "/" }, time: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "$view", properties: { "page" => "/products" }, time: 1.hour.ago)
  end

  describe "#call" do
    let(:input) { { params: { period: "today" }, request: request } }

    it "returns pages with view counts" do
      result = described_class.new(input).call
      expect(result[:success]).to be true
      pages = result[:data]
      home = pages.find { |p| p[:page] == "/" }
      expect(home[:views]).to eq(2)
    end

    it "orders by count descending" do
      result = described_class.new(input).call
      expect(result[:data].first[:page]).to eq("/")
    end
  end
end
