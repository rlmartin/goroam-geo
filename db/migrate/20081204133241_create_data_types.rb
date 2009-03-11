class CreateDataTypes < ActiveRecord::Migration
  def self.up
    create_table :data_types do |t|
      t.string :name

      t.timestamps
    end

	DataType.create(:name => 'Unknown')
	DataType.create(:name => 'Raw Text')
	DataType.create(:name => 'URL')
	DataType.create(:name => 'Image')
  end

  def self.down
    drop_table :data_types
  end
end
