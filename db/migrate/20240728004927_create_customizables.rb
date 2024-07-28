class CreateCustomizables < ActiveRecord::Migration[7.0]
  def change
    create_table :customizables do |t|
      t.string :name

      t.timestamps
    end
  end
end
