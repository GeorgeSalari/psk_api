# frozen_string_literal: true

require "rails_helper"

RSpec.describe Certificates::IndexService do
  let(:request) { fake_request }
  let(:serializer) { CertificateSerializer }

  before do
    create(:certificate, name: "Pub", display: true, position: 1)
    create(:certificate, name: "Hidden", display: false)
  end

  describe "#call" do
    context "with published_only" do
      let(:input) { { params: { published: "true" }, request: request } }

      it "returns only published certificates" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data].length).to eq(1)
        expect(result[:data].first[:name]).to eq("Pub")
      end
    end

    context "without published filter" do
      let(:input) { { params: { published: "" }, request: request } }

      it "returns all certificates" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data].length).to eq(2)
      end
    end
  end
end
