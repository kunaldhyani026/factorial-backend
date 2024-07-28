class CartItem < ApplicationRecord
  belongs_to :cart, validate: true
  belongs_to :product, validate: true

  has_and_belongs_to_many :customizable_options
end
