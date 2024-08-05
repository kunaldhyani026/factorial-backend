# spec/controllers/carts_controller_spec.rb
require 'rails_helper'

RSpec.describe CartsController, type: :controller do
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

  describe "POST #add_item" do
    it "adds an item to the cart" do
      post :add_item, params: { product_id: 1, customizable_options: [1, 4, 7, 10, 13] }
      expect(response).to have_http_status(:created)
      expect(response_body).to eq( { "cart_item_id" => 1})
    end
  end

  describe "GET #cart" do
    it "list cart items and total" do
      get :index
      expect(response.status).to eq(200)
      expect(response_body).to eq({"cart"=>
                                     {"cart_items"=>
                                        [{"id"=>1,
                                          "product"=>"Bicycle",
                                          "customizable_options"=>
                                            [{"id"=>1, "name"=>"Full Suspension", "price"=>300.0, "customizable_name"=>"Frame Type"},
                                             {"id"=>4, "name"=>"Matte", "price"=>50.0, "customizable_name"=>"Frame Finish"},
                                             {"id"=>7, "name"=>"Mountain Wheels", "price"=>200.0, "customizable_name"=>"Wheels"},
                                             {"id"=>10, "name"=>"Red", "price"=>10.0, "customizable_name"=>"Rim Color"},
                                             {"id"=>13, "name"=>"Single-speed chain", "price"=>150.0, "customizable_name"=>"Chain"}]}],
                                      "total"=>710.0}})
    end
  end
end

