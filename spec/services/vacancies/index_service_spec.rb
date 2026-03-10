# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vacancies::IndexService do
  let(:request) { fake_request }
  let(:serializer) { VacancySerializer }

  before do
    create(:vacancy, name: "Published Vacancy", display: true, position: 1)
    create(:vacancy, name: "Hidden Vacancy", display: false)
  end

  describe "#call" do
    context "with published_only" do
      let(:input) { { params: { published: "true" }, request: request } }

      it "returns only published vacancies" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data].length).to eq(1)
        expect(result[:data].first[:name]).to eq("Published Vacancy")
      end
    end

    context "without published filter" do
      let(:input) { { params: { published: "" }, request: request } }

      it "returns all vacancies" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data].length).to eq(2)
      end
    end
  end
end
