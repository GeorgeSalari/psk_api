# frozen_string_literal: true

class AdminAnalyticsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!

  def overview
    handle_result Analytics::OverviewService.new(input).call
  end

  def pages
    handle_result Analytics::PagesService.new(input).call
  end

  def events
    handle_result Analytics::EventsService.new(input).call
  end

  def visitors_chart
    handle_result Analytics::VisitorsChartService.new(input).call
  end

  private

  def input
    { params: { period: params[:period] }, request: request }
  end
end
