# spec/controllers/pricing_groups_controller_spec.rb
require 'rails_helper'

RSpec.describe PricingGroupsController, type: :controller do
  self.use_transactional_tests = false
  render_views

  before(:all) do
    Rails.application.load_seed
  end

  after(:all) do
    ActiveRecord::Base.connection.execute("DELETE FROM prohibitions")
    ActiveRecord::Base.connection.execute("DELETE FROM customizable_options_products")
    ActiveRecord::Base.connection.execute("DELETE FROM customizable_options_pricing_groups")
    ActiveRecord::Base.connection.execute("DELETE FROM cart_items_customizable_options")

    CustomizableOptionPriceByGroup.destroy_all
    PricingGroup.destroy_all
    CartItem.destroy_all
    Cart.destroy_all
    Customer.destroy_all
    CustomizableOption.destroy_all
    Product.destroy_all
    Customizable.destroy_all

    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence")
  end

  def response_body
    JSON.parse(response.body)
  end

  describe "POST #create" do
    it "creates a new pricing group and associated price" do
      post :create, params: {
        pricing_group_name: 'New Pricing Group',
        customizable_option_id: 10,
        price: 2000.0,
        customizable_option_combinations: [4, 5, 7]
      }

      expect(response.status).to eq(204)
      pricing_group = PricingGroup.last
      expect(pricing_group.name).to eq('New Pricing Group')
      expect(pricing_group.customizable_option_ids).to eq([4, 5, 7])
      expect(CustomizableOptionPriceByGroup.last.price).to eq(2000.0)
      expect(CustomizableOptionPriceByGroup.last.customizable_option_id).to eq(10)
      expect(CustomizableOptionPriceByGroup.last.pricing_group_id).to eq(pricing_group.id)
    end
  end
end

