# frozen_string_literal: true

require "rails_helper"

RSpec.describe Products::CreateContract do
  subject(:contract) { described_class.new(params) }

  let(:photo) { Rack::Test::UploadedFile.new(StringIO.new("fake"), "image/png", true, original_filename: "test.png") }

  context "with valid params" do
    let(:params) { { name: "Product A", description: "Desc", photos: [ photo ] } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "returns correct hash" do
      contract.valid?
      hash = contract.to_h
      expect(hash[:name]).to eq("Product A")
      expect(hash[:description]).to eq("Desc")
      expect(hash[:photos]).to eq([ photo ])
    end
  end

  context "with missing name" do
    let(:params) { { name: "", photos: [ photo ] } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes name error" do
      contract.valid?
      expect(contract.errors).to include("Name is required")
    end
  end

  context "with missing photos" do
    let(:params) { { name: "Product A", photos: [] } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes photo error" do
      contract.valid?
      expect(contract.errors).to include("At least one photo is required")
    end
  end

  context "with nil photos" do
    let(:params) { { name: "Product A", photos: nil } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end
  end

  context "with whitespace-only name" do
    let(:params) { { name: "   ", photos: [ photo ] } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end
  end
end
