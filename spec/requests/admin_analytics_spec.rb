# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Analytics", type: :request do
  let(:admin) { create(:admin) }
  let(:headers) { auth_headers(admin) }

  before do
    visit = create(:ahoy_visit, started_at: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "$view", properties: { "page" => "/" }, time: 1.hour.ago)
    create(:ahoy_event, visit: visit, name: "product_click", time: 1.hour.ago)
  end

  describe "GET /admin/analytics/overview" do
    context "with auth" do
      it "returns overview data" do
        get "/admin/analytics/overview", params: { period: "today" }, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to have_key("unique_visitors")
        expect(json).to have_key("total_views")
        expect(json).to have_key("total_events")
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        get "/admin/analytics/overview"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /admin/analytics/pages" do
    context "with auth" do
      it "returns page data" do
        get "/admin/analytics/pages", params: { period: "today" }, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to be_an(Array)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        get "/admin/analytics/pages"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /admin/analytics/events" do
    context "with auth" do
      it "returns event data" do
        get "/admin/analytics/events", params: { period: "today" }, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to be_an(Array)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        get "/admin/analytics/events"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /admin/analytics/visitors_chart" do
    context "with auth" do
      it "returns chart data" do
        get "/admin/analytics/visitors_chart", params: { period: "week" }, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to be_an(Array)
      end
    end

    context "without auth" do
      it "returns unauthorized" do
        get "/admin/analytics/visitors_chart"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
