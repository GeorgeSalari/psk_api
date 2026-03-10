# frozen_string_literal: true

require "rails_helper"

RSpec.describe CallRequests::SendEmailService do
  let!(:call_request) { create(:call_request) }

  describe "#call" do
    it "sends a notification email" do
      expect {
        described_class.new(call_request.id).call
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "updates email_sent_at" do
      described_class.new(call_request.id).call
      expect(call_request.reload.email_sent_at).to be_present
    end

    context "with non-existent id" do
      it "logs error and does not raise" do
        expect {
          described_class.new(-1).call
        }.not_to raise_error
      end
    end
  end
end
