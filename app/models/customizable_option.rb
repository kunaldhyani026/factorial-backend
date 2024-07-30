class CustomizableOption < ApplicationRecord
  belongs_to :customizable

  has_and_belongs_to_many :product
  has_and_belongs_to_many :cart_items

  has_and_belongs_to_many :prohibited_combinations,
                          class_name: 'CustomizableOption',
                          join_table: :prohibitions,
                          foreign_key: :customizable_option_id,
                          association_foreign_key: :prohibited_customizable_option_id

  has_many :customizable_option_price_by_groups
  has_many :pricing_groups, through: :customizable_option_price_by_groups
  has_and_belongs_to_many :pricing_groups

  def customizable_name
    customizable.name
  end

  def actual_price(other_selected_options)
    price = self.price
    customizable_option_price_by_groups.each do |customizable_option_price_group_mapping|
      pricing_group = customizable_option_price_group_mapping.pricing_group

      if pricing_group.customizable_options.all? { |option| other_selected_options.include?(option) }
        price = [price, customizable_option_price_group_mapping.price].max
      end
    end
    price
  end
end
