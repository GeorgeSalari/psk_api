# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::ToggleDisplayService do
  let(:request) { fake_request }

  describe "#call with Certificate" do
    let(:serializer) { CertificateSerializer }
    let!(:certificate) { create(:certificate, display: false, position: 0) }

    context "toggling to published" do
      let(:input) { { resource: Certificate, id: certificate.id, request: request } }

      it "sets display to true" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:display]).to be true
      end

      it "assigns position" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:data][:position]).to be > 0
      end
    end

    context "toggling to hidden" do
      let!(:published) { create(:certificate, display: true, position: 1) }
      let(:input) { { resource: Certificate, id: published.id, request: request } }

      it "sets display to false" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:display]).to be false
      end

      it "resets position to 0" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:data][:position]).to eq(0)
      end
    end

    context "with non-existent id" do
      let(:input) { { resource: Certificate, id: -1, request: request } }

      it "returns not_found" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:not_found]).to be true
      end
    end
  end

  describe "#call with Product" do
    let(:serializer) { ProductSerializer }
    let!(:product) { create(:product, display: false, position: 0) }
    let(:input) { { resource: Product, id: product.id, request: request } }

    it "toggles display" do
      result = described_class.new(input, serializer: serializer).call
      expect(result[:success]).to be true
      expect(result[:data][:display]).to be true
    end
  end

  describe "#call with Vacancy" do
    let(:serializer) { VacancySerializer }
    let!(:vacancy) { create(:vacancy, display: false, position: 0) }
    let(:input) { { resource: Vacancy, id: vacancy.id, request: request } }

    it "toggles display" do
      result = described_class.new(input, serializer: serializer).call
      expect(result[:success]).to be true
      expect(result[:data][:display]).to be true
    end
  end
end
