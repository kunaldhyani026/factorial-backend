class ProductsController < ApplicationController
  before_action :set_product, only: [:show ]

  def index
    @products = Product.all
  end

  def show
    @product
  end

  private

  def set_product
    begin
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_message = "Couldn't find Product with 'id'=#{params[:id]}"
      render_error('resource_not_found', 'invalid_request_error', error_message, 404)
    end
  end
end

