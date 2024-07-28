class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email, null: false, unique: true

      t.timestamps
    end
  end
end
