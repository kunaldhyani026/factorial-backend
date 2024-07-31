class CustomizableOptionsController < ApplicationController
  def index
    @products = Product.all
    @customizables = Customizable.all
    @customizable_options = CustomizableOption.all
  end

  def create
    option = CustomizableOption.create!(name: params[:name], price: params[:price], stock: params[:in_stock], customizable_id: params[:customizable_id])
    render json: option, status: :created
  end
end


