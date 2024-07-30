class CartsController < ApplicationController
  before_action :set_cart

  def add_item
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.new(product: product)
    cart_item.customizable_option_ids = params[:customizable_options]
    cart_item.save
    @cart.update(total: @cart.total_price)

    render json: { cart_item_id: cart_item.id }, status: :created
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by!(customer_id: $customer_id)
  end
end


