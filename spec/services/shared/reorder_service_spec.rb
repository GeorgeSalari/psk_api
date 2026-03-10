# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::ReorderService do
  describe "#call" do
    let!(:cert1) { create(:certificate, display: true, position: 1) }
    let!(:cert2) { create(:certificate, display: true, position: 2) }
    let!(:cert3) { create(:certificate, display: true, position: 3) }

    context "with valid ids" do
      let(:input) { { resource: Certificate, ids: [ cert3.id, cert1.id, cert2.id ] } }

      it "reorders positions" do
        result = described_class.new(input).call
        expect(result[:success]).to be true
        expect(cert3.reload.position).to eq(1)
        expect(cert1.reload.position).to eq(2)
        expect(cert2.reload.position).to eq(3)
      end
    end

    context "with empty ids" do
      let(:input) { { resource: Certificate, ids: [] } }

      it "returns failure" do
        result = described_class.new(input).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("IDs are required")
      end
    end

    context "with nil ids" do
      let(:input) { { resource: Certificate, ids: nil } }

      it "returns failure" do
        result = described_class.new(input).call
        expect(result[:success]).to be false
      end
    end
  end
end
