# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vacancies::UpdateService do
  let(:request) { fake_request }
  let(:serializer) { VacancySerializer }
  let!(:vacancy) { create(:vacancy, name: "Old Name") }

  describe "#call" do
    context "with valid name update" do
      let(:input) { { id: vacancy.id, params: { name: "New Name" }, request: request } }

      it "updates the vacancy" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:name]).to eq("New Name")
      end
    end

    context "with description update" do
      let(:input) { { id: vacancy.id, params: { description: "New desc" }, request: request } }

      it "updates description" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:description]).to eq("New desc")
      end
    end

    context "with photo update" do
      let(:photo) { fixture_file_upload("test.png", "image/png") }
      let(:input) { { id: vacancy.id, params: { photo: photo }, request: request } }

      it "attaches the photo" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(vacancy.reload.photo).to be_attached
      end
    end

    context "with blank name" do
      let(:input) { { id: vacancy.id, params: { name: "" }, request: request } }

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
