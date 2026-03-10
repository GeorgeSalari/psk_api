# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vacancies::CreateContract do
  subject(:contract) { described_class.new(params) }

  let(:photo) { Rack::Test::UploadedFile.new(StringIO.new("fake"), "image/png", true, original_filename: "test.png") }

  context "with valid params" do
    let(:params) { { name: "Developer", description: "Ruby dev", photo: photo } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "returns correct hash" do
      contract.valid?
      hash = contract.to_h
      expect(hash[:name]).to eq("Developer")
      expect(hash[:description]).to eq("Ruby dev")
      expect(hash[:photo]).to eq(photo)
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
    let(:params) { { name: "Developer", photo: nil } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes photo error" do
      contract.valid?
      expect(contract.errors).to include("Photo is required")
    end
  end
end
