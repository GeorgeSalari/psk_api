# frozen_string_literal: true

require "rails_helper"

RSpec.describe Analytics::OverviewService do
  let(:request) { fake_request }

  before do
    visit = create(:ahoy_visit, started_at: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "$view", time: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "product_click", time: 1.hour.ago)

    old_visit = create(:ahoy_visit, started_at: 2.months.ago)
    create(:ahoy_event, visit: old_visit, name: "$view", time: 2.months.ago)
  end

  describe "#call" do
    context "with period=today" do
      let(:input) { { params: { period: "today" }, request: request } }

      it "returns correct counts" do
        result = described_class.new(input).call
        expect(result[:success]).to be true
        expect(result[:data][:unique_visitors]).to eq(1)
        expect(result[:data][:total_views]).to eq(1)
        expect(result[:data][:total_events]).to eq(1)
      end
    end

    context "with period=month" do
      let(:input) { { params: { period: "month" }, request: request } }

      it "includes data from last 30 days" do
        result = described_class.new(input).call
        expect(result[:success]).to be true
        expect(result[:data][:unique_visitors]).to eq(1)
        expect(result[:data][:total_views]).to eq(1)
      end
    end

    context "with invalid period" do
      let(:input) { { params: { period: "year" }, request: request } }

      it "returns failure" do
        result = described_class.new(input).call
        expect(result[:success]).to be false
      end
    end
  end
end
