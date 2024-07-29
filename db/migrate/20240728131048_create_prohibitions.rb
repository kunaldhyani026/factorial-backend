class CreateProhibitions < ActiveRecord::Migration[7.0]
  def change
    create_table :prohibitions do |t|
      t.integer :customizable_option_id
      t.integer :prohibited_customizable_option_id
    end

    add_index :prohibitions, [:customizable_option_id, :prohibited_customizable_option_id], unique: true, name: 'index_prohibitions_on_customizable_and_prohibited'
    add_index :prohibitions, [:prohibited_customizable_option_id, :customizable_option_id], unique: true, name: 'index_prohibitions_on_prohibited_and_customizable'

    # Adding a check constraint to ensure both columns cannot have the same value
    # Commented because SQLite doesn't support adding check constraint post table creation
    # execute <<-QUERY
    #   ALTER TABLE prohibitions
    #   ADD CONSTRAINT check_different_customizable_options
    #   CHECK (customizable_option_id <> prohibited_customizable_option_id);
    # QUERY
  end
end
