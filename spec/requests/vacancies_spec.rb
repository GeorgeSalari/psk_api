# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Vacancies", type: :request do
  let(:admin) { create(:admin) }
  let(:headers) { auth_headers(admin) }
  let(:photo) { fixture_file_upload("test.png", "image/png") }

  describe "GET /vacancies" do
    before do
      create(:vacancy, name: "Published", display: true, position: 1)
      create(:vacancy, name: "Hidden", display: false)
    end

    it "returns published vacancies for public requests" do
      get "/vacancies", params: { published: "true" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first["name"]).to eq("Published")
    end

    it "returns all vacancies without published filter" do
      get "/vacancies"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end
  end

  describe "POST /vacancies" do
    context "with valid params and auth" do
      it "creates a vacancy" do
        expect {
          post "/vacancies", params: { name: "New Vacancy", description: "Desc", photo: photo }, headers: headers
        }.to change(Vacancy, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        post "/vacancies", params: { name: "New", photo: photo }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid params" do
      it "returns unprocessable_entity" do
        post "/vacancies", params: { name: "", photo: photo }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /vacancies/:id" do
    let!(:vacancy) { create(:vacancy, name: "Old") }

    context "with valid params and auth" do
      it "updates the vacancy" do
        patch "/vacancies/#{vacancy.id}", params: { name: "Updated" }, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Updated")
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        patch "/vacancies/#{vacancy.id}", params: { name: "Updated" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with non-existent id" do
      it "returns not_found" do
        patch "/vacancies/0", params: { name: "Updated" }, headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /vacancies/:id" do
    let!(:vacancy) { create(:vacancy) }

    context "with auth" do
      it "deletes the vacancy" do
        expect {
          delete "/vacancies/#{vacancy.id}", headers: headers
        }.to change(Vacancy, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        delete "/vacancies/#{vacancy.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /vacancies/:id/toggle_display" do
    let!(:vacancy) { create(:vacancy, display: false) }

    context "with auth" do
      it "toggles display" do
        patch "/vacancies/#{vacancy.id}/toggle_display", headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["display"]).to be true
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        patch "/vacancies/#{vacancy.id}/toggle_display"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /vacancies/reorder" do
    let!(:v1) { create(:vacancy, display: true, position: 1) }
    let!(:v2) { create(:vacancy, display: true, position: 2) }

    context "with auth" do
      it "reorders vacancies" do
        patch "/vacancies/reorder", params: { ids: [ v2.id, v1.id ] }, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(v2.reload.position).to eq(1)
        expect(v1.reload.position).to eq(2)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        patch "/vacancies/reorder", params: { ids: [ v2.id, v1.id ] }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
