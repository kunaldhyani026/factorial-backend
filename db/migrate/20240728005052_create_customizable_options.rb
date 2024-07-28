class CreateCustomizableOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :customizable_options do |t|
      t.string :name
      t.references :customizable, null: false, foreign_key: true
      t.float :price, default: 0

      t.timestamps
    end
  end
end
