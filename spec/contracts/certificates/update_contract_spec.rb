# frozen_string_literal: true

require "rails_helper"

RSpec.describe Certificates::UpdateContract do
  subject(:contract) { described_class.new(params) }

  let(:photo) { Rack::Test::UploadedFile.new(StringIO.new("fake"), "image/png", true, original_filename: "test.png") }

  context "with valid name and photo" do
    let(:params) { { name: "Updated", photo: photo } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "includes both in to_h" do
      contract.valid?
      hash = contract.to_h
      expect(hash[:name]).to eq("Updated")
      expect(hash[:photo]).to eq(photo)
    end
  end

  context "with only name" do
    let(:params) { { name: "Updated" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "only includes name in to_h" do
      contract.valid?
      expect(contract.to_h).to eq({ name: "Updated" })
    end
  end

  context "with only photo" do
    let(:params) { { photo: photo } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "only includes photo in to_h" do
      contract.valid?
      expect(contract.to_h.keys).to eq([ :photo ])
    end
  end

  context "with blank name" do
    let(:params) { { name: "" } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes error" do
      contract.valid?
      expect(contract.errors).to include("Name cannot be blank")
    end
  end

  context "with no params" do
    let(:params) { {} }

    it "is valid (no-op update)" do
      expect(contract).to be_valid
    end

    it "returns empty hash" do
      contract.valid?
      expect(contract.to_h).to eq({})
    end
  end
end
