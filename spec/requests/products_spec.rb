# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Products", type: :request do
  let(:admin) { create(:admin) }
  let(:headers) { auth_headers(admin) }
  let(:photo) { fixture_file_upload("test.png", "image/png") }

  describe "GET /products" do
    before do
      create(:product, name: "Published", display: true, position: 1)
      create(:product, name: "Hidden", display: false)
    end

    it "returns published products for public requests" do
      get "/products", params: { published: "true" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first["name"]).to eq("Published")
    end

    it "returns all products without published filter" do
      get "/products"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end
  end

  describe "GET /products/:id (show by slug)" do
    let!(:product) { create(:product, name: "My Product", display: true, position: 1) }

    it "returns product by slug" do
      get "/products/#{product.slug}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("My Product")
      expect(json["slug"]).to eq(product.slug)
    end

    context "with unpublished product" do
      let!(:hidden) { create(:product, name: "Hidden Product", display: false) }

      it "returns not_found" do
        get "/products/#{hidden.slug}"
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with non-existent slug" do
      it "returns not_found" do
        get "/products/no-such-slug"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /products" do
    context "with valid params and auth" do
      it "creates a product" do
        expect {
          post "/products", params: { name: "New Product", description: "Desc", photos: [ photo ] }, headers: headers
        }.to change(Product, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        post "/products", params: { name: "New", photos: [ photo ] }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid params" do
      it "returns unprocessable_entity" do
        post "/products", params: { name: "" }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /products/:id" do
    let!(:product) { create(:product, name: "Old") }

    context "with valid params and auth" do
      it "updates the product" do
        patch "/products/#{product.id}", params: { name: "Updated" }, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Updated")
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        patch "/products/#{product.id}", params: { name: "Updated" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /products/:id" do
    let!(:product) { create(:product) }

    context "with auth" do
      it "deletes the product" do
        expect {
          delete "/products/#{product.id}", headers: headers
        }.to change(Product, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        delete "/products/#{product.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /products/:id/toggle_display" do
    let!(:product) { create(:product, display: false) }

    context "with auth" do
      it "toggles display" do
        patch "/products/#{product.id}/toggle_display", headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["display"]).to be true
      end
    end
  end

  describe "PATCH /products/reorder" do
    let!(:p1) { create(:product, display: true, position: 1) }
    let!(:p2) { create(:product, display: true, position: 2) }

    context "with auth" do
      it "reorders products" do
        patch "/products/reorder", params: { ids: [ p2.id, p1.id ] }, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(p2.reload.position).to eq(1)
        expect(p1.reload.position).to eq(2)
      end
    end
  end
end
