# frozen_string_literal: true

require "rails_helper"

RSpec.describe Analytics::PeriodContract do
  subject(:contract) { described_class.new(params) }

  %w[today week month].each do |period|
    context "with period '#{period}'" do
      let(:params) { { period: period } }

      it "is valid" do
        expect(contract).to be_valid
      end
    end
  end

  context "with blank period" do
    let(:params) { { period: "" } }

    it "is valid (defaults to month)" do
      expect(contract).to be_valid
    end
  end

  context "with nil period" do
    let(:params) { { period: nil } }

    it "is valid" do
      expect(contract).to be_valid
    end
  end

  context "with invalid period" do
    let(:params) { { period: "year" } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes error" do
      contract.valid?
      expect(contract.errors).to include("Invalid period")
    end
  end

  describe "#start_date" do
    it "returns beginning of day for 'today'" do
      contract = described_class.new(period: "today")
      expect(contract.start_date).to be_within(1.second).of(Time.current.beginning_of_day)
    end

    it "returns 7 days ago for 'week'" do
      contract = described_class.new(period: "week")
      expect(contract.start_date).to be_within(1.second).of(7.days.ago.beginning_of_day)
    end

    it "returns 30 days ago for 'month'" do
      contract = described_class.new(period: "month")
      expect(contract.start_date).to be_within(1.second).of(30.days.ago.beginning_of_day)
    end

    it "defaults to 30 days ago for blank period" do
      contract = described_class.new(period: "")
      expect(contract.start_date).to be_within(1.second).of(30.days.ago.beginning_of_day)
    end
  end
end
