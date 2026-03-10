# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Sessions", type: :request do
  let!(:admin) { create(:admin, email: "admin@test.com", password: "secret123") }

  describe "POST /admin/sign_in" do
    context "with valid credentials" do
      it "returns a JWT token" do
        post "/admin/sign_in", params: { email: "admin@test.com", password: "secret123" }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["token"]).to be_present
      end
    end

    context "with invalid password" do
      it "returns unauthorized" do
        post "/admin/sign_in", params: { email: "admin@test.com", password: "wrong" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with non-existent email" do
      it "returns unauthorized" do
        post "/admin/sign_in", params: { email: "nobody@test.com", password: "secret123" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with missing email" do
      it "returns unprocessable_entity" do
        post "/admin/sign_in", params: { email: "", password: "secret123" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
