# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090302130534) do

  create_table "api_logs", :force => true do |t|
    t.string   "api_url"
    t.boolean  "valid_url"
    t.string   "requesting_url"
    t.string   "requesting_host"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constants", :force => true do |t|
    t.string   "name",        :default => ""
    t.text     "value"
    t.string   "server_type", :default => ""
    t.string   "lang",        :default => ""
    t.string   "cast_as",     :default => ""
    t.boolean  "array",       :default => false
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "constants", ["active"], :name => "index_constants_on_active"
  add_index "constants", ["cast_as"], :name => "index_constants_on_cast_as"
  add_index "constants", ["lang"], :name => "index_constants_on_lang"
  add_index "constants", ["name"], :name => "index_constants_on_name"
  add_index "constants", ["server_type", "active", "name"], :name => "index_constants_on_server_type_and_active_and_name"
  add_index "constants", ["server_type", "active"], :name => "index_constants_on_server_type_and_active"
  add_index "constants", ["server_type"], :name => "index_constants_on_server_type"

  create_table "data_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geo_points", :force => true do |t|
    t.decimal  "lat",        :precision => 22, :scale => 17
    t.decimal  "lng",        :precision => 22, :scale => 17
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geo_points", ["lat", "lng"], :name => "index_geo_points_on_lat_and_lng", :unique => true

  create_table "geo_points_items", :id => false, :force => true do |t|
    t.integer  "geo_point_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geo_points_items", ["geo_point_id", "item_id"], :name => "index_geo_points_items_on_geo_point_id_and_item_id", :unique => true
  add_index "geo_points_items", ["geo_point_id"], :name => "index_geo_points_items_on_geo_point_id"
  add_index "geo_points_items", ["item_id"], :name => "index_geo_points_items_on_item_id"

  create_table "items", :force => true do |t|
    t.string   "title"
    t.string   "value"
    t.integer  "data_type_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["data_type_id"], :name => "index_items_on_data_type_id"

end
