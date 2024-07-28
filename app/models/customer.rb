class Customer < ApplicationRecord
  has_one :cart

  validates :email, presence: true, uniqueness: true
end
