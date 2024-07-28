class Product < ApplicationRecord
  has_and_belongs_to_many :customizable_options

  validates :name, presence: true, uniqueness: true
end
