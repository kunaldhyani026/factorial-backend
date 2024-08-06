class CartItem < ApplicationRecord
  belongs_to :cart, validate: true
  belongs_to :product, validate: true

  has_and_belongs_to_many :customizable_options

  # Sum the prices of all customizable options associated with the cart item
  def total_price
    price = 0
    customizable_options.each do |customizable_option|
      price += customizable_option.actual_price(customizable_options)
    end
    price
  end
end
