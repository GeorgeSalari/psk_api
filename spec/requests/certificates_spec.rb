# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Certificates", type: :request do
  let(:admin) { create(:admin) }
  let(:headers) { auth_headers(admin) }
  let(:photo) { fixture_file_upload("test.png", "image/png") }

  describe "GET /certificates" do
    before do
      create(:certificate, name: "Published", display: true, position: 1)
      create(:certificate, name: "Hidden", display: false)
    end

    it "returns published certificates for public requests" do
      get "/certificates", params: { published: "true" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first["name"]).to eq("Published")
    end

    it "returns all certificates without published filter" do
      get "/certificates"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end
  end

  describe "POST /certificates" do
    context "with valid params and auth" do
      it "creates a certificate" do
        expect {
          post "/certificates", params: { name: "New Cert", photo: photo }, headers: headers
        }.to change(Certificate, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        post "/certificates", params: { name: "New Cert", photo: photo }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid params" do
      it "returns unprocessable_entity" do
        post "/certificates", params: { name: "", photo: photo }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /certificates/:id" do
    let!(:certificate) { create(:certificate, name: "Old") }

    context "with valid params and auth" do
      it "updates the certificate" do
        patch "/certificates/#{certificate.id}", params: { name: "Updated" }, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Updated")
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        patch "/certificates/#{certificate.id}", params: { name: "Updated" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with non-existent id" do
      it "returns not_found" do
        patch "/certificates/0", params: { name: "Updated" }, headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /certificates/:id" do
    let!(:certificate) { create(:certificate) }

    context "with auth" do
      it "deletes the certificate" do
        expect {
          delete "/certificates/#{certificate.id}", headers: headers
        }.to change(Certificate, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        delete "/certificates/#{certificate.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /certificates/:id/toggle_display" do
    let!(:certificate) { create(:certificate, display: false) }

    context "with auth" do
      it "toggles display" do
        patch "/certificates/#{certificate.id}/toggle_display", headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["display"]).to be true
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        patch "/certificates/#{certificate.id}/toggle_display"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /certificates/reorder" do
    let!(:c1) { create(:certificate, display: true, position: 1) }
    let!(:c2) { create(:certificate, display: true, position: 2) }

    context "with auth" do
      it "reorders certificates" do
        patch "/certificates/reorder", params: { ids: [ c2.id, c1.id ] }, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(c2.reload.position).to eq(1)
        expect(c1.reload.position).to eq(2)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        patch "/certificates/reorder", params: { ids: [ c2.id, c1.id ] }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
