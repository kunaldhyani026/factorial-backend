class CreateJoinTablePricingGroupsCustomizableOptions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :pricing_groups, :customizable_options do |t|
      t.index [:pricing_group_id, :customizable_option_id], unique: true, name: 'uniq_pricing_group_id_customizable_option_id'
      t.index [:customizable_option_id, :pricing_group_id], name: 'index_customizable_option_id_pricing_group_id'
    end
  end
end
