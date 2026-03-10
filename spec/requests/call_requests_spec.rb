# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CallRequests", type: :request do
  let(:admin) { create(:admin) }
  let(:headers) { auth_headers(admin) }

  describe "POST /call_requests" do
    context "with valid params" do
      let(:params) { { contact_name: "Иван", phone: "+79181234567", comment: "Перезвоните" } }

      it "creates a call request" do
        expect {
          post "/call_requests", params: params
        }.to change(CallRequest, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "enqueues an email job" do
        expect {
          post "/call_requests", params: params
        }.to have_enqueued_job(CallRequestEmailJob)
      end
    end

    context "with invalid phone" do
      it "returns unprocessable_entity" do
        post "/call_requests", params: { contact_name: "Иван", phone: "12345" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with missing contact_name" do
      it "returns unprocessable_entity" do
        post "/call_requests", params: { contact_name: "", phone: "+79181234567" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /call_requests" do
    before do
      create(:call_request, called: false)
      create(:call_request, called: true)
    end

    context "with auth" do
      it "returns pending requests by default" do
        get "/call_requests", params: { filter: "pending" }, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.length).to eq(1)
        expect(json.first["called"]).to be false
      end

      it "returns processed requests" do
        get "/call_requests", params: { filter: "processed" }, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.length).to eq(1)
        expect(json.first["called"]).to be true
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        get "/call_requests"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /call_requests/:id/change_state" do
    let!(:call_request) { create(:call_request, called: false) }

    context "with auth" do
      it "toggles the called state" do
        post "/call_requests/#{call_request.id}/change_state", headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["called"]).to be true
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        post "/call_requests/#{call_request.id}/change_state"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with non-existent id" do
      it "returns not_found" do
        post "/call_requests/0/change_state", headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
