# These are methods to be used as an "include" library in other classes.
# The methods in this library deal with Hashes.
module DistLib
	protected
  # This is for use with GeoKit and should be used in conjunction with convert_units
	def self.convert_distance(dist, units = nil)
    dist = dist.to_f
    unless (units == nil) or (units == ""): units = units.to_sym end
    case units
      when :km, :kilometer, :kms, :kilometers
        dist
      when :m, :meter, :ms, :meters
        dist / 1000
      when :mi, :mile, :mis, :miles
        dist
      when :yd, :yard, :yds, :yards
        dist / 1760
      when :ft, :feet, :foot
        dist / 5280
      else
        dist
    end
	end

  # This is for use with GeoKit and should be used in conjunction with convert_distance
	def self.convert_units(units = nil)
    unless (units == nil) or (units == ""): units = units.to_sym end
    case units
      when :km, :kilometer, :kms, :kilometers
        :kms
      when :m, :meter, :ms, :meters
        :kms
      when :mi, :mile, :mis, :miles
        :miles
      when :yd, :yard, :yds, :yards
        :miles
      when :ft, :feet, :foot
        :miles
      else
        :miles
    end
	end

  # The units parameter must be either :kms or :miles, which should be fine if it the input is first run through
  # convert_units (above).
  def self.units_text(units)
    case units
      when :kms
        Constant::get(:kilometers_text)
      when :miles
        Constant::get(:miles_text)
    end
  end
end
