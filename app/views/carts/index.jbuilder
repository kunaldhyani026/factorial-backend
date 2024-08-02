cart_items = []
@cart.cart_items.each do |cart_item|
  cart_items << {
    id: cart_item.id,
    product: cart_item.product.name,
    customizable_options: cart_item.customizable_options.map { |option| { id: option.id, name: option.name, price: Float(option.actual_price(cart_item.customizable_options)), customizable_name: option.customizable.name } }
  }
end

json.cart do
  json.cart_items cart_items
  json.total cart_items.flat_map { |item| item[:customizable_options].map { |option| option[:price] } }.sum
end