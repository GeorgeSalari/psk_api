# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminAuth::SignInContract do
  subject(:contract) { described_class.new(params) }

  context "with valid params" do
    let(:params) { { email: "admin@example.com", password: "secret123" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "returns sanitized hash" do
      contract.valid?
      expect(contract.to_h).to eq({ email: "admin@example.com", password: "secret123" })
    end

    it "strips whitespace from email" do
      contract_ws = described_class.new(email: "  admin@example.com  ", password: "secret123")
      contract_ws.valid?
      expect(contract_ws.to_h[:email]).to eq("admin@example.com")
    end
  end

  context "with missing email" do
    let(:params) { { email: "", password: "secret123" } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes email error" do
      contract.valid?
      expect(contract.errors).to include("Email is required")
    end
  end

  context "with missing password" do
    let(:params) { { email: "admin@example.com", password: "" } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes password error" do
      contract.valid?
      expect(contract.errors).to include("Password is required")
    end
  end

  context "with both missing" do
    let(:params) { { email: nil, password: nil } }

    it "returns both errors" do
      contract.valid?
      expect(contract.errors).to contain_exactly("Email is required", "Password is required")
    end
  end
end
