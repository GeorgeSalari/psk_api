# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vacancies::UpdateContract do
  subject(:contract) { described_class.new(params) }

  let(:photo) { Rack::Test::UploadedFile.new(StringIO.new("fake"), "image/png", true, original_filename: "test.png") }

  context "with valid name" do
    let(:params) { { name: "Updated" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "includes name in to_h" do
      contract.valid?
      expect(contract.to_h[:name]).to eq("Updated")
    end
  end

  context "with description" do
    let(:params) { { description: "New desc" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "includes description in to_h" do
      contract.valid?
      expect(contract.to_h[:description]).to eq("New desc")
    end
  end

  context "with photo" do
    let(:params) { { photo: photo } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "includes photo in to_h" do
      contract.valid?
      expect(contract.to_h[:photo]).to eq(photo)
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

    it "is valid" do
      expect(contract).to be_valid
    end

    it "returns empty hash" do
      contract.valid?
      expect(contract.to_h).to eq({})
    end
  end
end
