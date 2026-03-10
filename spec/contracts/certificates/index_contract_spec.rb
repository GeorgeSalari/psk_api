# frozen_string_literal: true

require "rails_helper"

RSpec.describe Certificates::IndexContract do
  subject(:contract) { described_class.new(params) }

  context "with published=true" do
    let(:params) { { published: "true" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "sets published_only to true" do
      contract.valid?
      expect(contract.to_h[:published_only]).to be true
    end
  end

  context "with published=false" do
    let(:params) { { published: "false" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "sets published_only to false" do
      contract.valid?
      expect(contract.to_h[:published_only]).to be false
    end
  end

  context "with blank published" do
    let(:params) { { published: "" } }

    it "is valid" do
      expect(contract).to be_valid
    end

    it "sets published_only to false" do
      contract.valid?
      expect(contract.to_h[:published_only]).to be false
    end
  end

  context "with nil published" do
    let(:params) { { published: nil } }

    it "is valid" do
      expect(contract).to be_valid
    end
  end
end
