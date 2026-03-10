# frozen_string_literal: true

class ProductsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index, :show ]

  def index
    published_only = params[:published] == "true"
    result = Products::IndexService.new(
      serializer: ProductSerializer,
      request: request,
      published_only: published_only
    ).call
    render json: result[:data]
  end

  def show
    result = Products::ShowService.new(params[:id], serializer: ProductSerializer, request: request).call
    handle_result(result)
  end

  def create
    result = Products::CreateService.new(product_params, serializer: ProductSerializer, request: request).call
    handle_result(result, success_status: :created)
  end

  def update
    result = Products::UpdateService.new(params[:id], product_params, serializer: ProductSerializer, request: request).call
    handle_result(result)
  end

  def destroy
    result = Products::DestroyService.new(params[:id]).call
    handle_result(result, success_status: :no_content)
  end

  def toggle_display
    result = Shared::ToggleDisplayService.new(Product, params[:id], serializer: ProductSerializer, request: request).call
    handle_result(result)
  end

  def reorder
    result = Shared::ReorderService.new(Product, params[:ids]).call
    handle_result(result, success_status: :no_content)
  end

  private

  def product_params
    params.permit(:name, :description, :photo_positions, photos: [], remove_photo_ids: [])
  end
end
