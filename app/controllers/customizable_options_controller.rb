class CustomizableOptionsController < ApplicationController
  def index
    @products = Product.all
    @customizables = Customizable.all
    @customizable_options = CustomizableOption.all
  end
end


