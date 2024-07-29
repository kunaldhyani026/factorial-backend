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

  def render_error(code, type, message, http_status_code)
    render json: { error: { code: code, message: message, type: type } }, status: http_status_code
  end
end

