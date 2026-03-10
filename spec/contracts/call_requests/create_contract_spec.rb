# frozen_string_literal: true

require "rails_helper"

RSpec.describe CallRequests::CreateContract do
  subject(:contract) { described_class.new(params) }

  context "with valid params" do
    let(:params) { { contact_name: "Иван", phone: "+79181234567", comment: "Перезвоните" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "returns correct hash" do
      contract.valid?
      hash = contract.to_h
      expect(hash[:contact_name]).to eq("Иван")
      expect(hash[:phone]).to eq("+79181234567")
      expect(hash[:comment]).to eq("Перезвоните")
    end
  end

  context "with 8-prefix phone" do
    let(:params) { { contact_name: "Иван", phone: "89181234567" } }

    it "is valid" do
      expect(contract).to be_valid
    end
  end

  context "with phone containing spaces and dashes" do
    let(:params) { { contact_name: "Иван", phone: "+7 (918) 123-45-67" } }

    it "is valid (normalizes phone)" do
      expect(contract).to be_valid
    end

    it "normalizes phone in to_h" do
      contract.valid?
      expect(contract.to_h[:phone]).to eq("+79181234567")
    end
  end

  context "with invalid phone format" do
    let(:params) { { contact_name: "Иван", phone: "12345" } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes phone error" do
      contract.valid?
      expect(contract.errors).to include("Введите корректный российский номер телефона")
    end
  end

  context "with missing contact_name" do
    let(:params) { { contact_name: "", phone: "+79181234567" } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes name error" do
      contract.valid?
      expect(contract.errors).to include("Имя обязательно для заполнения")
    end
  end

  context "with missing phone" do
    let(:params) { { contact_name: "Иван", phone: "" } }

    it "is invalid" do
      expect(contract).not_to be_valid
    end

    it "includes phone required error" do
      contract.valid?
      expect(contract.errors).to include("Телефон обязателен для заполнения")
    end
  end

  context "with blank comment" do
    let(:params) { { contact_name: "Иван", phone: "+79181234567", comment: "" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "sets comment to nil" do
      contract.valid?
      expect(contract.to_h[:comment]).to be_nil
    end
  end
end
