# frozen_string_literal: true

require "rails_helper"

RSpec.describe Products::ShowService do
  let(:request) { fake_request }
  let(:serializer) { ProductSerializer }
  let!(:product) { create(:product, name: "Test Product", display: true, position: 1) }

  describe "#call" do
    context "with valid slug for published product" do
      let(:input) { { id: product.slug, request: request } }

      it "returns success with product data" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:name]).to eq("Test Product")
        expect(result[:data][:slug]).to eq(product.slug)
      end
    end

    context "with slug for unpublished product" do
      let(:hidden) { create(:product, name: "Hidden", display: false) }
      let(:input) { { id: hidden.slug, request: request } }

      it "returns not_found" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:not_found]).to be true
      end
    end

    context "with non-existent slug" do
      let(:input) { { id: "no-such-slug", request: request } }

      it "returns not_found" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:not_found]).to be true
      end
    end
  end
end
