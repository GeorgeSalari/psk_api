# frozen_string_literal: true

require "rails_helper"

RSpec.describe Certificates::CreateContract do
  subject(:contract) { described_class.new(params) }

  let(:photo) { Rack::Test::UploadedFile.new(StringIO.new("fake"), "image/png", true, original_filename: "test.png") }

  context "with valid params" do
    let(:params) { { name: "ISO 9001", photo: photo } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "returns correct hash" do
      contract.valid?
      expect(contract.to_h[:name]).to eq("ISO 9001")
      expect(contract.to_h[:photo]).to eq(photo)
    end
  end

  context "with missing name" do
    let(:params) { { name: "", photo: photo } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes name error" do
      contract.valid?
      expect(contract.errors).to include("Name is required")
    end
  end

  context "with missing photo" do
    let(:params) { { name: "ISO 9001", photo: nil } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes photo error" do
      contract.valid?
      expect(contract.errors).to include("Photo is required")
    end
  end

  context "with whitespace-only name" do
    let(:params) { { name: "   ", photo: photo } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end
  end
end
