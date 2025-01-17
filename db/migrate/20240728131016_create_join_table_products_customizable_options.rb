class CreateJoinTableProductsCustomizableOptions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :products, :customizable_options do |t|
      t.index [:product_id, :customizable_option_id], unique: true, name: 'uniq_product_id_customizable_option_id'
      t.index [:customizable_option_id, :product_id], name: 'index_customizable_option_id_product_id'
    end
  end
end
