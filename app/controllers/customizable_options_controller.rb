class CustomizableOptionsController < ApplicationController
  def index
    @products = Product.all
    @customizables = Customizable.all
    @customizable_options = CustomizableOption.all
  end

  def create
    option = CustomizableOption.new(name: params[:name], price: params[:price], stock: params[:in_stock], customizable_id: params[:customizable_id])
    option.product_ids = params[:product_ids]
    option.save!
    render json: option, status: :created
  end

  def update
    customizable_option = CustomizableOption.find(params[:id])
    customizable_option.update!(price: params[:price])
  end
end


