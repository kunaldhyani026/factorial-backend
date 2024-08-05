# spec/controllers/customizable_options_controller_spec.rb
require 'rails_helper'

RSpec.describe CustomizableOptionsController, type: :controller do
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
    it "returns a list of customizable options" do
      get :index
      expect(response.status).to eq(200)
      expect(response_body).to eq({"products"=>[{"id"=>1, "name"=>"Bicycle"}, {"id"=>2, "name"=>"Surfboard"}],
                                   "customizables"=>
                                     [{"id"=>1, "name"=>"Frame Type"}, {"id"=>2, "name"=>"Frame Finish"}, {"id"=>3, "name"=>"Wheels"}, {"id"=>4, "name"=>"Rim Color"}, {"id"=>5, "name"=>"Chain"}],
                                   "customizable_options"=>
                                     [{"id"=>1, "customizable_id"=>1, "name"=>"Full Suspension", "price"=>300.0, "stock"=>true},
                                      {"id"=>2, "customizable_id"=>1, "name"=>"Diamond", "price"=>150.0, "stock"=>true},
                                      {"id"=>3, "customizable_id"=>1, "name"=>"step-through", "price"=>100.0, "stock"=>true},
                                      {"id"=>4, "customizable_id"=>2, "name"=>"Matte", "price"=>40.0, "stock"=>true},
                                      {"id"=>5, "customizable_id"=>2, "name"=>"Shiny", "price"=>30.0, "stock"=>true},
                                      {"id"=>6, "customizable_id"=>3, "name"=>"Road Wheels", "price"=>100.0, "stock"=>true},
                                      {"id"=>7, "customizable_id"=>3, "name"=>"Mountain Wheels", "price"=>200.0, "stock"=>true},
                                      {"id"=>8, "customizable_id"=>3, "name"=>"Fat Bike Wheels", "price"=>300.0, "stock"=>true},
                                      {"id"=>9, "customizable_id"=>3, "name"=>"Non-Rusty Tiny Wheels", "price"=>120.0, "stock"=>true},
                                      {"id"=>10, "customizable_id"=>4, "name"=>"Red", "price"=>10.0, "stock"=>true},
                                      {"id"=>11, "customizable_id"=>4, "name"=>"Blue", "price"=>20.0, "stock"=>true},
                                      {"id"=>12, "customizable_id"=>4, "name"=>"Black", "price"=>5.0, "stock"=>false},
                                      {"id"=>13, "customizable_id"=>5, "name"=>"Single-speed chain", "price"=>150.0, "stock"=>true},
                                      {"id"=>14, "customizable_id"=>5, "name"=>"8-speed chain", "price"=>400.0, "stock"=>true}]})
    end
  end

  describe "POST #create" do
    it "creates a new customizable option" do
      post :create, params: {
        name: 'Tiny Grass Wheels',
        price: 400,
        in_stock: false,
        customizable_id: 3,
        product_ids: [2]
      }
      expect(response).to have_http_status(:created)
      customizable_option = CustomizableOption.last
      expect(customizable_option.name).to eq('Tiny Grass Wheels')
      expect(customizable_option.product_ids).to eq([2])
    end
  end

  describe "PATCH #update" do
    it "updates a customizable option" do
      tiny_grass_wheels = CustomizableOption.find_by_name('Tiny Grass Wheels')
      expect(tiny_grass_wheels.price).to eq(400.0)

      patch :update, params: { id: tiny_grass_wheels.id, price: 800.0 }
      expect(response.status).to eq(204)

      expect(tiny_grass_wheels.reload.price).to eq(800.0)
    end
  end
end

