# frozen_string_literal: true

class ProductsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index, :show ]

  def index
    handle_result result
  end

  def show
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
    service.new(input, serializer: ProductSerializer).call
  end

  def service
    "Products::#{action_name.camelize}Service".constantize
  rescue NameError
    "Shared::#{action_name.camelize}Service".constantize
  end

  def input
    { resource: Product, id: params[:id], ids: params[:ids], params: product_params, request: request }
  end

  def product_params
    params.permit(:name, :description, :photo_positions, :published, photos: [], remove_photo_ids: [])
  end
end
