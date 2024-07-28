class CreateJoinTableCartItemsCustomizableOptions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :cart_items, :customizable_options do |t|
      t.index [:cart_item_id, :customizable_option_id], unique: true, name: 'uniq_cart_item_id_customizable_option_id'
      t.index [:customizable_option_id, :cart_item_id], name: 'index_customizable_option_id_cart_item_id'
    end
  end
end
