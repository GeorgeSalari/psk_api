# frozen_string_literal: true

require "rails_helper"

RSpec.describe Certificates::CreateService do
  let(:request) { fake_request }
  let(:serializer) { CertificateSerializer }
  let(:photo) { fixture_file_upload("test.png", "image/png") }

  describe "#call" do
    context "with valid params" do
      let(:input) { { params: { name: "ISO 9001", photo: photo }, request: request } }

      it "creates a certificate" do
        expect {
          described_class.new(input, serializer: serializer).call
        }.to change(Certificate, :count).by(1)
      end

      it "returns success with serialized data" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:name]).to eq("ISO 9001")
      end
    end

    context "with missing name" do
      let(:input) { { params: { name: "", photo: photo }, request: request } }

      it "returns failure" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Name is required")
      end
    end

    context "with missing photo" do
      let(:input) { { params: { name: "ISO 9001", photo: nil }, request: request } }

      it "returns failure" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Photo is required")
      end
    end
  end
end
