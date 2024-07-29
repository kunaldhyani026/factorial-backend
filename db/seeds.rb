# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

CustomizableOptionPriceByGroup.destroy_all
CustomizableOption.destroy_all
Customizable.destroy_all
Product.destroy_all
Customer.destroy_all
PricingGroup.destroy_all
CartItem.destroy_all
Cart.destroy_all

# customers
kunal = Customer.find_or_create_by(name: 'Kunal Dhyani', email: 'kunaldhyani@email.com')
neeraj = Customer.find_or_create_by(name: 'Neeraj Chopra', email: 'neeraj-javelin@email.com')

# products
bike = Product.find_or_create_by(name: 'Bicycle', description: 'Customize your bicycle')
surfboard = Product.find_or_create_by(name: 'Surfboard', description: 'Customize your surfboard')

# customizables and their options
frame_type = Customizable.create(name: 'Frame Type')
frame_type.customizable_options.create([{name:'Full Suspension', price: 300}, {name:'Diamond', price: 150}, {name:'step-through', price: 100}])

frame_finish = Customizable.create(name: 'Frame Finish')
frame_finish.customizable_options.create([{name:'Matte', price: 40}, {name:'Shiny', price: 30}])

wheels = Customizable.create(name: 'Wheels')
wheels.customizable_options.create([{name:'Road Wheels', price: 100}, {name:'Mountain Wheels', price: 200}, {name:'Fat Bike Wheels', price: 300}, {name:'Non-Rusty Tiny Wheels', price: 120}])

rim_color = Customizable.create(name: 'Rim Color')
rim_color.customizable_options.create([{name:'Red', price: 10}, {name:'Blue', price: 20}, {name:'Black', price: 5, stock: false}])

chain = Customizable.create(name: 'Chain')
chain.customizable_options.create([{name:'Single-speed chain', price: 150}, {name:'8-speed chain', price: 400}])

# Adding prohibited combinations
wheels.customizable_options.find_by_name('Mountain Wheels').prohibited_combinations << [
  frame_type.customizable_options.find_by_name('Diamond'),
  frame_type.customizable_options.find_by_name('step-through')
]
frame_type.customizable_options.find_by_name('Diamond').prohibited_combinations << [wheels.customizable_options.find_by_name('Mountain Wheels')]
frame_type.customizable_options.find_by_name('step-through').prohibited_combinations << [wheels.customizable_options.find_by_name('Mountain Wheels')]

wheels.customizable_options.find_by_name('Fat Bike Wheels').prohibited_combinations << rim_color.customizable_options.find_by_name('Red')
rim_color.customizable_options.find_by_name('Red').prohibited_combinations << wheels.customizable_options.find_by_name('Fat Bike Wheels')

# Pricing Groups
full_suspension_frame_group = PricingGroup.create(name: 'Full Suspension Frame Group')
diamond_frame_group = PricingGroup.create(name: 'Diamond Group')
summer_sale = PricingGroup.create(name: 'Summer Sale')

# Pricing Group Customizable Options
full_suspension_frame_group.customizable_options << CustomizableOption.find_by_name('Full Suspension')
diamond_frame_group.customizable_options << CustomizableOption.find_by_name('Diamond')
summer_sale.customizable_options << [CustomizableOption.find_by_name('step-through'), CustomizableOption.find_by_name('Road Wheels')]

# CustomizableOptions Pricing by Group
CustomizableOption.find_by_name('Matte').customizable_option_price_by_groups << CustomizableOptionPriceByGroup.create({price: 50, pricing_group_id: full_suspension_frame_group.id})
CustomizableOption.find_by_name('Matte').customizable_option_price_by_groups << CustomizableOptionPriceByGroup.create({price: 35, pricing_group_id: diamond_frame_group.id})
CustomizableOption.find_by_name('Shiny').customizable_option_price_by_groups << CustomizableOptionPriceByGroup.create({price: 10, pricing_group_id: summer_sale.id})

# Add customizable_options to products
bike.customizable_options = CustomizableOption.where.not(name: 'Non-Rusty Tiny Wheels')
surfboard.customizable_options = CustomizableOption.where(name: 'Non-Rusty Tiny Wheels')
