# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminAuth::SignInService do
  let(:admin) { create(:admin, email: "admin@test.com", password: "secret123") }
  let(:request) { fake_request }

  describe "#call" do
    context "with valid credentials" do
      let(:input) { { params: { email: admin.email, password: "secret123" }, request: request } }

      it "returns success with token" do
        result = described_class.new(input).call
        expect(result[:success]).to be true
        expect(result[:data][:token]).to be_present
      end

      it "encodes admin_id in token" do
        result = described_class.new(input).call
        decoded = JwtService.decode(result[:data][:token])
        expect(decoded[:admin_id]).to eq(admin.id)
      end
    end

    context "with invalid password" do
      let(:input) { { params: { email: admin.email, password: "wrong" }, request: request } }

      it "returns unauthorized" do
        result = described_class.new(input).call
        expect(result[:success]).to be false
        expect(result[:unauthorized]).to be true
      end
    end

    context "with non-existent email" do
      let(:input) { { params: { email: "missing@test.com", password: "secret123" }, request: request } }

      it "returns unauthorized" do
        result = described_class.new(input).call
        expect(result[:success]).to be false
        expect(result[:unauthorized]).to be true
      end
    end

    context "with missing email" do
      let(:input) { { params: { email: "", password: "secret123" }, request: request } }

      it "returns failure from contract" do
        result = described_class.new(input).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Email is required")
      end
    end

    context "with missing password" do
      let(:input) { { params: { email: "admin@test.com", password: "" }, request: request } }

      it "returns failure from contract" do
        result = described_class.new(input).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Password is required")
      end
    end
  end
end
