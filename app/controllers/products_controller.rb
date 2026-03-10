# frozen_string_literal: true

class ProductsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index, :show ]

  def index
    handle_result Products::IndexService.new(input, serializer: ProductSerializer).call
  end

  def show
    handle_result Products::ShowService.new(input, serializer: ProductSerializer).call
  end

  def create
    handle_result Products::CreateService.new(input, serializer: ProductSerializer).call, success_status: :created
  end

  def update
    handle_result Products::UpdateService.new(input, serializer: ProductSerializer).call
  end

  def destroy
    handle_result Products::DestroyService.new(input).call, success_status: :no_content
  end

  def toggle_display
    handle_result Shared::ToggleDisplayService.new(input, serializer: ProductSerializer).call
  end

  def reorder
    handle_result Shared::ReorderService.new(input).call, success_status: :no_content
  end

  private

  def input
    { resource: Product, id: params[:id], ids: params[:ids], params: product_params, request: request }
  end

  def product_params
    params.permit(:name, :description, :photo_positions, :published, photos: [], remove_photo_ids: [])
  end
end
