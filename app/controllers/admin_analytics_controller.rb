# frozen_string_literal: true

class AdminAnalyticsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!

  def overview
    handle_result result
  end

  def pages
    handle_result result
  end

  def events
    handle_result result
  end

  def visitors_chart
    handle_result result
  end

  private

  def result
    service.new(input).call
  end

  def service
    "Analytics::#{action_name.camelize}Service".constantize
  end

  def input
    { params: { period: params[:period] }, request: request }
  end
end
