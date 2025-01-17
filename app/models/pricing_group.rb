class PricingGroup < ApplicationRecord
  has_many :customizable_option_price_by_groups
  has_many :customizable_options, through: :customizable_option_price_by_groups
  has_and_belongs_to_many :customizable_options
end
