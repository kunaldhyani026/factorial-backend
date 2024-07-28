class CreateJoinTablePricingGroupsCustomizableOptions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :pricing_groups, :customizable_options do |t|
      t.index [:pricing_group_id, :customizable_option_id], unique: true, name: 'uniq_pricing_group_id_customizable_option_id'
      t.index [:customizable_option_id, :pricing_group_id], name: 'index_customizable_option_id_pricing_group_id'
    end

    # Rename the table to the desired name since Rails create_join_table created name by alphabetic order joining
    rename_table :customizable_options_pricing_groups, :pricing_groups_customizable_options
  end
end
