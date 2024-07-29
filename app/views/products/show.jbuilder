customizables = @product.customizable_options.includes(:customizable).map do |option|
  {
    id: option.customizable.id,
    name: option.customizable.name
  }
end.uniq { |c| c[:id] }

customizable_options_hash = {}
@product.customizable_options.includes(:customizable, :prohibited_combinations).each do |option|
  customizable_name = option.customizable.name
  customizable_options_hash[customizable_name] ||= []
  customizable_options_hash[customizable_name] << {
    id: option.id,
    name: option.name,
    price: option.price,
    stock: option.stock,
    prohibited_combinations: option.prohibited_combinations.map { |prohibited| prohibited.id }
  }
end

json.product do
  json.extract! @product, :id, :name, :description
end
json.customizables customizables
json.customizable_options customizable_options_hash
