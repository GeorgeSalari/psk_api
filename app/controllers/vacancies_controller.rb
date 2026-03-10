# frozen_string_literal: true

class VacanciesController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index ]

  def index
    published_only = params[:published] == "true"
    result = Vacancies::IndexService.new(
      serializer: VacancySerializer,
      request: request,
      published_only: published_only
    ).call
    render json: result[:data]
  end

  def create
    result = Vacancies::CreateService.new(vacancy_params, serializer: VacancySerializer, request: request).call
    handle_result(result, success_status: :created)
  end

  def update
    result = Vacancies::UpdateService.new(params[:id], vacancy_params, serializer: VacancySerializer, request: request).call
    handle_result(result)
  end

  def destroy
    result = Vacancies::DestroyService.new(params[:id]).call
    handle_result(result, success_status: :no_content)
  end

  def toggle_display
    result = Shared::ToggleDisplayService.new(Vacancy, params[:id], serializer: VacancySerializer, request: request).call
    handle_result(result)
  end

  def reorder
    result = Shared::ReorderService.new(Vacancy, params[:ids]).call
    handle_result(result, success_status: :no_content)
  end

  private

  def vacancy_params
    params.permit(:name, :description, :photo)
  end
end
