# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vacancies::DestroyService do
  let!(:vacancy) { create(:vacancy) }

  describe "#call" do
    context "with valid id" do
      let(:input) { { id: vacancy.id } }

      it "destroys the vacancy" do
        expect {
          described_class.new(input).call
        }.to change(Vacancy, :count).by(-1)
      end

      it "returns success" do
        result = described_class.new(input).call
        expect(result[:success]).to be true
      end
    end

    context "with non-existent id" do
      let(:input) { { id: -1 } }

      it "returns not_found" do
        result = described_class.new(input).call
        expect(result[:success]).to be false
        expect(result[:not_found]).to be true
      end
    end
  end
end
