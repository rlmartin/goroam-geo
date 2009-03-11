class GeoPointsItems < ActiveRecord::Migration
  def self.up
	create_table :geo_points_items, :id => false do |t|
		t.integer :geo_point_id
		t.integer :item_id
		t.timestamps
	end

	add_index :geo_points_items, [:geo_point_id]
	add_index :geo_points_items, [:item_id]
	add_index :geo_points_items, [:geo_point_id, :item_id], :unique => true
  end

  def self.down
	drop_table :geo_points_items
  end
end
