# frozen_string_literal: true

class AdminAnalyticsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!

  def overview
    handle_result Analytics::OverviewService.new(period_params).call
  end

  def pages
    handle_result Analytics::PagesService.new(period_params).call
  end

  def events
    handle_result Analytics::EventsService.new(period_params).call
  end

  def visitors_chart
    handle_result Analytics::VisitorsChartService.new(period_params).call
  end

  private

  def period_params
    { period: params[:period] }
  end
end
