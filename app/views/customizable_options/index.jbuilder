json.products do
  json.array! @products do |product|
    json.extract! product, :id, :name
  end
end

json.customizables do
  json.array! @customizables do |customizable|
    json.extract! customizable, :id, :name
  end
end

json.customizable_options do
  json.array! @customizable_options do |customizable_option|
    json.extract! customizable_option, :id, :customizable_id, :name, :price, :stock
  end
end