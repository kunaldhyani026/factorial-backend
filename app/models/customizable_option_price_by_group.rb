class CustomizableOptionPriceByGroup < ApplicationRecord
  belongs_to :customizable_option
  belongs_to :pricing_group
end
