class GeoPointsController < ApplicationController
	include DistLib
  before_filter :before_filter_get_geo_point
  before_filter :before_filter_detect_item_search_constraints
  before_filter :before_filter_find_main_item
  before_filter :before_filter_define_page_properties

  def index
    @items = @geo_point.items.latest(@limit, @offset)
    @items_geo_point = @geo_point
    #	respond_to do | format |
    #		format.html
    #		format.xml { :mime_type => Mime::Type["text/xml"] }
    #		format.json { render :json => @geo_point.to_json }
    #	end
  end

  def find_within(order = '')
    @units = DistLib.convert_units(params[:units])
    @within = DistLib.convert_distance(params[:within], params[:units])
    @page[:description] += ", within #{@within} #{DistLib.units_text(@units)}"
    if order == '': order = 'distance' end
    options = { :origin => @geo_point, :within => @within, :units => @units, :order => order }
    if @offset > 0: options.merge!({ :offset => @offset }) end
    if @limit > 0: options.merge!({ :limit => @limit }) end
    @items = Item.find_mappable(:all, options)
    render :template => "geo_points/index"
  end

  def find_within_latest
    find_within('`items`.created_at DESC')
    #render :template => "geo_points/index"
  end

  protected
  def before_filter_find_main_item
    unless params[:find] == nil: @main_item = Item.find_mappable(:first, :conditions => {:value => params[:find]}) end
  end

  def before_filter_define_page_properties
    @page[:title] = "Lat/Lng (#{@geo_point.lat_s}, #{@geo_point.lng_s})"
    @page[:keywords] = "#{@geo_point.lat_s} #{@geo_point.lng_s}"
    @page[:description] = "Items geotagged at (#{@geo_point.lat_s}, #{@geo_point.lng_s})"
    @page[:rss_link] = request.url.chomp('.htm').chomp('.html') + ".rss"
    if ((params[:layout] != nil) and (params[:layout].downcase == 'min'))
      @page[:page_class] = 'min_layout'
      @page[:api_settings] = 'controls-min'
      @page[:header] = 'layouts/header_min'
      @page[:footer] = 'layouts/footer_min'
    end
    if defined?(@main_item) and (@main_item != nil) and (@main_item.title != ''): @page[:title] += " : #{@main_item.title}" end
  end
end
