class ConstantsChangeValueColumn < ActiveRecord::Migration
  def self.up
    change_column :constants, :value, :text
  end

  def self.down
    change_column :constants, :value, :string
  end
end
