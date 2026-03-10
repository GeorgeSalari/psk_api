# frozen_string_literal: true

require "rails_helper"

RSpec.describe Products::UpdateContract do
  subject(:contract) { described_class.new(params) }

  let(:photo) { Rack::Test::UploadedFile.new(StringIO.new("fake"), "image/png", true, original_filename: "test.png") }

  context "with valid name" do
    let(:params) { { name: "Updated" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "includes name in to_h" do
      contract.valid?
      expect(contract.to_h).to eq({ name: "Updated" })
    end
  end

  context "with photos and remove_photo_ids" do
    let(:params) { { photos: [ photo ], remove_photo_ids: [ "1", "2" ] } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "casts remove_photo_ids to integers" do
      contract.valid?
      expect(contract.to_h[:remove_photo_ids]).to eq([ 1, 2 ])
    end

    it "includes photos in to_h" do
      contract.valid?
      expect(contract.to_h[:photos]).to eq([ photo ])
    end
  end

  context "with photo_positions" do
    let(:params) { { photo_positions: "[3,1,2]" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "includes photo_positions in to_h" do
      contract.valid?
      expect(contract.to_h[:photo_positions]).to eq("[3,1,2]")
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
