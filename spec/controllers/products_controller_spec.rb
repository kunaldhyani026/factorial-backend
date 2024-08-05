# spec/controllers/products_controller_spec.rb
require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
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

  describe "GET #index" do
    it "returns a list of products" do
      get :index
      expect(response.status).to eq(200)
      expect(response_body).to eq([
                                    {"id"=>1, "name"=>"Bicycle", "description"=>"Customize your bicycle"},
                                    {"id"=>2, "name"=>"Surfboard", "description"=>"Customize your surfboard"}
                                  ])
    end
  end

  describe "GET #show" do
    it "returns the requested product" do
      get :show, params: { id: 2 }
      expect(response.status).to eq(200)
      expect(response_body).to eq({"product"=>{"id"=>2, "name"=>"Surfboard", "description"=>"Customize your surfboard"},
                                   "customizables"=>[{"id"=>3, "name"=>"Wheels"}],
                                   "customizable_options"=>{"Wheels"=>[{"id"=>9, "name"=>"Non-Rusty Tiny Wheels", "price"=>120.0, "stock"=>true, "prohibited_combinations"=>[]}]}})
    end
  end

  describe "POST #create" do
    it "creates a new product" do
      post :create, params: { product_name: 'New Product', product_description: 'Description here', customizable_options: [1, 2, 3] }
      expect(response.status).to eq(201)
      product = Product.last
      expect(product.name).to eq('New Product')
      expect(product.customizable_option_ids).to eq([1, 2, 3])
    end
  end
end

