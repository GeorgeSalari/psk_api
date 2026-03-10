# frozen_string_literal: true

require "rails_helper"

RSpec.describe CallRequests::CreateService do
  let(:request) { fake_request }
  let(:serializer) { CallRequestSerializer }

  describe "#call" do
    context "with valid params" do
      let(:input) { { params: { contact_name: "Иван", phone: "+79181234567", comment: "Перезвоните" }, request: request } }

      it "creates a call request" do
        expect {
          described_class.new(input, serializer: serializer).call
        }.to change(CallRequest, :count).by(1)
      end

      it "returns success" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be true
        expect(result[:data][:contact_name]).to eq("Иван")
      end

      it "enqueues email job" do
        expect {
          described_class.new(input, serializer: serializer).call
        }.to have_enqueued_job(CallRequestEmailJob)
      end
    end

    context "with missing contact_name" do
      let(:input) { { params: { contact_name: "", phone: "+79181234567" }, request: request } }

      it "returns failure" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
      end
    end

    context "with invalid phone" do
      let(:input) { { params: { contact_name: "Иван", phone: "12345" }, request: request } }

      it "returns failure" do
        result = described_class.new(input, serializer: serializer).call
        expect(result[:success]).to be false
      end
    end
  end
end
