# frozen_string_literal: true

class VacanciesController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index ]
  before_action :set_vacancy, only: [ :update, :destroy ]

  def index
    result = Vacancies::IndexService.new(serializer: VacancySerializer, request: request).call
    render json: result[:data]
  end

  def create
    result = Vacancies::CreateService.new(vacancy_params, serializer: VacancySerializer, request: request).call

    if result[:success]
      render json: result[:data], status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def update
    result = Vacancies::UpdateService.new(@vacancy, vacancy_params, serializer: VacancySerializer, request: request).call

    if result[:success]
      render json: result[:data]
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    result = Vacancies::DestroyService.new(@vacancy).call

    if result[:success]
      head :no_content
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_vacancy
    @vacancy = Vacancy.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Vacancy not found" }, status: :not_found
  end

  def vacancy_params
    params.permit(:name, :description, :photo)
  end
end
