# frozen_string_literal: true

require "rails_helper"

RSpec.describe Products::CreateService do
  let(:request) { fake_request }
  let(:serializer) { ProductSerializer }
  let(:photo) { fixture_file_upload("test.png", "image/png") }

  describe "#call" do
    context "with valid params" do
      let(:input) { { params: { name: "New Product", description: "A description", photos: [ photo ] }, request: request } }

      it "creates a product" do
        expect {
          described_class.new(input, serializer: serializer).call
        }.to change(Product, :count).by(1)
      end

      it "returns success with serialized data" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:name]).to eq("New Product")
        expect(result[:data][:slug]).to be_present
      end

      it "attaches photos" do
        described_class.new(input, serializer: serializer).call
        expect(Product.last.photos).to be_attached
      end
    end

    context "with missing name" do
      let(:input) { { params: { name: "", photos: [ photo ] }, request: request } }

      it "returns failure" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Name is required")
      end
    end

    context "with missing photos" do
      let(:input) { { params: { name: "Product", photos: [] }, request: request } }

      it "returns failure" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("At least one photo is required")
      end
    end
  end
end
