class GeoPoint < ActiveRecord::Base
  include StringLib
	acts_as_mappable
  # I'm not sure that :uniq => true really does anything here.
	has_and_belongs_to_many :items, :uniq => true do
    def latest(limit = 0, offset = 0)
      if (offset > 0)
        # This defines a range, not a simple limit
        find :all, :order => '`items`.created_at DESC', :limit => limit, :offset => offset
      elsif limit > 0
        # Simple limit requested
        find :all, :order => '`items`.created_at DESC', :limit => limit
      else
        find :all, :order => '`items`.created_at DESC'
      end
    end
  end

  def lat_s
    "#{StringLib.trim(StringLib.trim(lat.to_s, '0'), '.')}"
  end

  def lng_s
    "#{StringLib.trim(StringLib.trim(lng.to_s, '0'), '.')}"
  end

  def to_param
    "#{lat_s}/#{lng_s}"
  end
end
