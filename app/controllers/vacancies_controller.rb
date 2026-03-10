# frozen_string_literal: true

class VacanciesController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index ]

  def index
    handle_result Vacancies::IndexService.new(input, serializer: VacancySerializer).call
  end

  def create
    handle_result Vacancies::CreateService.new(input, serializer: VacancySerializer).call, success_status: :created
  end

  def update
    handle_result Vacancies::UpdateService.new(input, serializer: VacancySerializer).call
  end

  def destroy
    handle_result Vacancies::DestroyService.new(input).call, success_status: :no_content
  end

  def toggle_display
    handle_result Shared::ToggleDisplayService.new(input, serializer: VacancySerializer).call
  end

  def reorder
    handle_result Shared::ReorderService.new(input).call, success_status: :no_content
  end

  private

  def input
    { resource: Vacancy, id: params[:id], ids: params[:ids], params: vacancy_params, request: request }
  end

  def vacancy_params
    params.permit(:name, :description, :photo, :published)
  end
end
