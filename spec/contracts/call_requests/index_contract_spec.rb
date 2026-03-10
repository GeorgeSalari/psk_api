# frozen_string_literal: true

require "rails_helper"

RSpec.describe CallRequests::IndexContract do
  subject(:contract) { described_class.new(params) }

  context "with filter=pending" do
    let(:params) { { filter: "pending" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "returns pending in to_h" do
      contract.valid?
      expect(contract.to_h[:filter]).to eq("pending")
    end
  end

  context "with filter=processed" do
    let(:params) { { filter: "processed" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "returns processed in to_h" do
      contract.valid?
      expect(contract.to_h[:filter]).to eq("processed")
    end
  end

  context "with blank filter" do
    let(:params) { { filter: "" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "defaults to pending" do
      contract.valid?
      expect(contract.to_h[:filter]).to eq("pending")
    end
  end

  context "with invalid filter" do
    let(:params) { { filter: "invalid" } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes error" do
      contract.valid?
      expect(contract.errors).to include("Invalid filter")
    end
  end
end
