require 'test_helper'

class ItemTest < ActiveSupport::TestCase
	def test_data_type
		assert_equal items(:one).data_type, data_types(:image)
	end

	def test_lat_lng
		# item.lat & item.lng end up as strings, thus the .to_d
		assert_equal items(:one).lat.to_d, geo_points(:cb).lat
		assert_equal items(:one).lng.to_d, geo_points(:cb).lng
	end

	def test_acts_as_mappable
		# should be the same, thus the disance should be 0
		assert_equal items(:two).distance_to(geo_points(:ec)), 0
		# compare ints, thus the .to_i
		assert_equal items(:one).distance_to(geo_points(:tudorcity)).to_i, 1747
		assert_equal items(:one).distance_to(geo_points(:oldebirch)), geo_points(:cb).distance_to(geo_points(:oldebirch))
	end
end
