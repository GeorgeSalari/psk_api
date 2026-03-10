# frozen_string_literal: true

class VacanciesController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index ]

  def index
    handle_result result
  end

  def create
    handle_result result, success_status: :created
  end

  def update
    handle_result result
  end

  def destroy
    handle_result result, success_status: :no_content
  end

  def toggle_display
    handle_result result
  end

  def reorder
    handle_result result, success_status: :no_content
  end

  private

  def result
    service.new(input, serializer: VacancySerializer).call
  end

  def service
    "Vacancies::#{action_name.camelize}Service".constantize
  rescue NameError
    "Shared::#{action_name.camelize}Service".constantize
  end

  def input
    { resource: Vacancy, id: params[:id], ids: params[:ids], params: vacancy_params, request: request }
  end

  def vacancy_params
    params.permit(:name, :description, :photo, :published)
  end
end
