class PricingGroupsController < ApplicationController
  def create
    pricing_group = PricingGroup.new(name: params[:pricing_group_name])
    pricing_group.customizable_option_ids = params[:customizable_option_combinations]
    pricing_group.save!
    CustomizableOptionPriceByGroup.create!(customizable_option_id: params[:customizable_option_id], pricing_group_id: pricing_group.id, price: params[:price])
  end
end



