class CreateCustomizableOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :customizable_options do |t|
      t.string :name
      t.references :customizable, null: false, foreign_key: true
      t.float :price, default: 0, null: false
      t.boolean :stock, default: true

      t.timestamps
    end

    add_index :customizable_options, [:customizable_id, :name], unique: true
  end
end
