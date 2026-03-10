# frozen_string_literal: true

require "rails_helper"

RSpec.describe Analytics::VisitorsChartService do
  let(:request) { fake_request }

  before do
    create(:ahoy_visit, visitor_token: "v1", started_at: Time.current.beginning_of_day + 1.hour)
    create(:ahoy_visit, visitor_token: "v2", started_at: Time.current.beginning_of_day + 2.hours)
    create(:ahoy_visit, visitor_token: "v3", started_at: 1.day.ago.beginning_of_day + 3.hours)
  end

  describe "#call" do
    let(:input) { { params: { period: "week" }, request: request } }

    it "returns daily visitor counts" do
      result = described_class.new(input).call
      expect(result[:success]).to be true
      expect(result[:data]).to be_an(Array)

      today_data = result[:data].find { |d| d[:day] == Date.current.to_s }
      expect(today_data[:visitors]).to eq(2)
    end

    context "with period=today" do
      let(:input) { { params: { period: "today" }, request: request } }

      it "returns only today" do
        result = described_class.new(input).call
        expect(result[:success]).to be true
        expect(result[:data].length).to eq(1)
      end
    end
  end
end
