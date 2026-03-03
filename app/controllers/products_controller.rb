# frozen_string_literal: true

class ProductsController < ApplicationController
  include Authenticatable

  before_action :authenticate_admin!, except: [ :index, :show ]
  before_action :set_product, only: [ :show, :update, :destroy ]

  def index
    result = Products::IndexService.new(serializer: ProductSerializer, request: request).call
    render json: result[:data]
  end

  def show
    result = Products::ShowService.new(@product, serializer: ProductSerializer, request: request).call
    render json: result[:data]
  end

  def create
    result = Products::CreateService.new(product_params, serializer: ProductSerializer, request: request).call

    if result[:success]
      render json: result[:data], status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def update
    result = Products::UpdateService.new(@product, product_params, serializer: ProductSerializer, request: request).call

    if result[:success]
      render json: result[:data]
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    result = Products::DestroyService.new(@product).call

    if result[:success]
      head :no_content
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def product_params
    params.permit(:name, :description, :photo)
  end
end
