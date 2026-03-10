# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vacancies::CreateService do
  let(:request) { fake_request }
  let(:serializer) { VacancySerializer }
  let(:photo) { fixture_file_upload("test.png", "image/png") }

  describe "#call" do
    context "with valid params" do
      let(:input) { { params: { name: "Ruby Dev", description: "Build APIs", photo: photo }, request: request } }

      it "creates a vacancy" do
        expect {
          described_class.new(input, serializer: serializer).call
        }.to change(Vacancy, :count).by(1)
      end

      it "returns success with serialized data" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:name]).to eq("Ruby Dev")
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
      let(:input) { { params: { name: "Ruby Dev", photo: nil }, request: request } }

      it "returns failure" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Photo is required")
      end
    end
  end
end
