# frozen_string_literal: true

require "rails_helper"

RSpec.describe CallRequests::ChangeStateService do
  let(:request) { fake_request }
  let(:serializer) { CallRequestSerializer }

  describe "#call" do
    context "toggling from pending to processed" do
      let!(:call_request) { create(:call_request, called: false) }
      let(:input) { { id: call_request.id, request: request } }

      it "sets called to true" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:called]).to be true
      end
    end

    context "toggling from processed to pending" do
      let!(:call_request) { create(:call_request, called: true) }
      let(:input) { { id: call_request.id, request: request } }

      it "sets called to false" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:called]).to be false
      end
    end

    context "with non-existent id" do
      let(:input) { { id: -1, request: request } }

      it "returns not_found" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
        expect(result[:not_found]).to be true
      end
    end
  end
end
