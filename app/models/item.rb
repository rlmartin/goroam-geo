class Item < ActiveRecord::Base
	include ArgsLib
  include StringLib
  # This acts_as_mappable will only work when lat/lng are joined from the geo_point table.
  # Or use find_mappable below.
	acts_as_mappable :lat_lng_table_name => "geo_points"
  xss_terminate :sanitize => [:value, :title]
	belongs_to :data_type
	has_and_belongs_to_many :geo_points, :uniq => true
	#validates_uniqueness_of :geo_points

	def self.find_mappable(*args)
		ArgsLib.append_option! args, :joins, [:geo_points], [:all], 1
		ArgsLib.append_option! args, :select, "items.*, geo_points.lat, geo_points.lng", [:all], 1
		find(*args)
	end

  def lat_s
    "#{StringLib.trim(StringLib.trim(lat.to_s, '0'), '.')}"
  end

  def lng_s
    "#{StringLib.trim(StringLib.trim(lng.to_s, '0'), '.')}"
  end
end
