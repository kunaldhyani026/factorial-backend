class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items, source: :product

  validates :customer, uniqueness: true

  # Method to calculate the total price of the cart
  def total_price
    cart_items.sum(&:total_price)
  end
end
