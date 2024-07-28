class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.float :total, default: 0
      t.references :customer, null: true, foreign_key: true, unique: true

      t.timestamps
    end
  end
end
