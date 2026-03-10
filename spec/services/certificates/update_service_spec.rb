# frozen_string_literal: true

require "rails_helper"

RSpec.describe Certificates::UpdateService do
  let(:request) { fake_request }
  let(:serializer) { CertificateSerializer }
  let!(:certificate) { create(:certificate, name: "Old Name") }

  describe "#call" do
    context "with valid name update" do
      let(:input) { { id: certificate.id, params: { name: "New Name" }, request: request } }

      it "updates the certificate" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:name]).to eq("New Name")
      end
    end

    context "with photo update" do
      let(:photo) { fixture_file_upload("test.png", "image/png") }
      let(:input) { { id: certificate.id, params: { photo: photo }, request: request } }

      it "attaches the photo" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(certificate.reload.photo).to be_attached
      end
    end

    context "with blank name" do
      let(:input) { { id: certificate.id, params: { name: "" }, request: request } }

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
  end
end
