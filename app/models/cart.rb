class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items, source: :product

  validates :customer, uniqueness: true

  # Method to calculate the total price of the cart
  def total_price
    cart_items.sum do |cart_item|
      cart_item_total_price(cart_item)
    end
  end

  private

  # Helper method to calculate the total price of a specific cart item
  def cart_item_total_price(cart_item)
    # Sum the prices of all customizable options associated with the cart item
    price = 0
    cart_item_customizable_options = cart_item.customizable_options
    cart_item_customizable_options.each do |cart_item_customizable_option|
      price += cart_item_customizable_option.actual_price(cart_item_customizable_options)
    end
    price
  end
end
