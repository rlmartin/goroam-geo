class CreateGeoPoints < ActiveRecord::Migration
  def self.up
    create_table :geo_points do |t|
      t.column :lat, :decimal, :precision => 22, :scale => 17
      t.column :lng, :decimal, :precision => 22, :scale => 17

      t.timestamps
    end
	add_index :geo_points, [:lat, :lng], :unique => true
  end

  def self.down
    drop_table :geo_points
  end
end
