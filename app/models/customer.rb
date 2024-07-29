class Customer < ApplicationRecord
  has_one :cart, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
