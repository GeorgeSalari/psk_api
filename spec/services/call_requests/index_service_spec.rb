# frozen_string_literal: true

require "rails_helper"

RSpec.describe CallRequests::IndexService do
  let(:request) { fake_request }
  let(:serializer) { CallRequestSerializer }

  before do
    create(:call_request, contact_name: "Pending", called: false)
    create(:call_request, contact_name: "Processed", called: true)
  end

  describe "#call" do
    context "with filter=pending" do
      let(:input) { { params: { filter: "pending" }, request: request } }

      it "returns only pending requests" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data].length).to eq(1)
        expect(result[:data].first[:contact_name]).to eq("Pending")
      end
    end

    context "with filter=processed" do
      let(:input) { { params: { filter: "processed" }, request: request } }

      it "returns only processed requests" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data].length).to eq(1)
        expect(result[:data].first[:contact_name]).to eq("Processed")
      end
    end

    context "with blank filter (defaults to pending)" do
      let(:input) { { params: { filter: "" }, request: request } }

      it "returns pending requests" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data].length).to eq(1)
        expect(result[:data].first[:called]).to be false
      end
    end

    context "with invalid filter" do
      let(:input) { { params: { filter: "invalid" }, request: request } }

      it "returns failure" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
      end
    end
  end
end
