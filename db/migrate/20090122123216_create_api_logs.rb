class CreateApiLogs < ActiveRecord::Migration
  def self.up
    create_table :api_logs do |t|
      t.string :api_url
      t.boolean :valid_url
      t.string :requesting_url
      t.string :requesting_host
      t.string :ip_address

      t.timestamps
    end
  end

  def self.down
    drop_table :api_logs
  end
end
