# frozen_string_literal: true

require "rails_helper"

RSpec.describe Products::UpdateService do
  let(:request) { fake_request }
  let(:serializer) { ProductSerializer }
  let(:photo) { fixture_file_upload("test.png", "image/png") }
  let!(:product) { create(:product, name: "Old Name") }

  describe "#call" do
    context "with valid name update" do
      let(:input) { { id: product.id, params: { name: "New Name" }, request: request } }

      it "updates the product" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:name]).to eq("New Name")
      end

      it "regenerates slug" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:data][:slug]).to eq("new-name")
      end
    end

    context "with description update" do
      let(:input) { { id: product.id, params: { description: "Updated desc" }, request: request } }

      it "updates description" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:description]).to eq("Updated desc")
      end
    end

    context "with blank name" do
      let(:input) { { id: product.id, params: { name: "" }, request: request } }

      it "returns failure" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Name cannot be blank")
      end
    end

    context "with non-existent id" do
      let(:input) { { id: -1, params: { name: "New" }, request: request } }

      it "returns not_found" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:not_found]).to be true
      end
    end

    context "with new photos" do
      let(:input) { { id: product.id, params: { photos: [ photo ] }, request: request } }

      it "attaches new photos" do
        described_class.new(input, serializer: serializer).call
        expect(product.reload.photos).to be_attached
      end
    end
  end
end
