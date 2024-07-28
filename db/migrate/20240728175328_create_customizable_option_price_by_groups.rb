class CreateCustomizableOptionPriceByGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :customizable_option_price_by_groups do |t|
      t.references :customizable_option, null: false, foreign_key: true, name: 'fk_customizable_option_id', index: { name: 'idx_customizable_option_id' }
      t.references :pricing_group, null: false, foreign_key: true, name: 'fk_pricing_group_id', index: { name: 'idx_pricing_group_id' }
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end
    add_index :customizable_option_price_by_groups, [:customizable_option_id, :pricing_group_id], unique: true, name: 'uniq_customizable_option_id_pricing_group_id'
  end
end
