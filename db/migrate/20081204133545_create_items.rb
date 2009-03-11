class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title
      t.string :value
	t.integer :data_type_id, :null => false

      t.timestamps
    end

	add_index :items, [:data_type_id]
  end

  def self.down
    drop_table :items
  end
end
