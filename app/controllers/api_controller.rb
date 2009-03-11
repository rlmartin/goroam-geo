class ApiController < ApplicationController
  include GeoKit::Geocoders
  include RequestLib
  include StringLib
  before_filter [:before_filter_map_action_to_version, :before_filter_check_key, :before_filter_get_url], :except => [:index, :xdcomm]
  before_filter [:before_filter_load_version, :before_filter_load_settings]
  before_filter :before_filter_load_default_settings, :except => [:index, :xdcomm]
  after_filter :after_filter_track_api_request, :except => [:index, :xdcomm]

  def index
    # Build the requested api url
    @api_url = ""
    arrTemp = @settings.sort { |a, b| a.to_s <=> b.to_s }
    arrTemp.each do | setting |
      @api_url += "/#{setting[0]}-#{setting[1]}"
    end
    @api_url = "#{RequestLib.server_name(request)}/api_/v#{@version.gsub(/\W+/, "-")}#{@api_url}.js"
  end

  protected
  def rescue_action(exception)
    case exception
      when ::ActionController::RoutingError, ::ActionController::UnknownAction then
        after_filter_track_api_request(false)
        render :action => "invalid_api"
      else super
    end
  end

  def before_filter_check_key
    # If I wanted to make the js scripts more secure, I could add a single-use key check here,
    # i.e. generate a key in the index action & store it in the db, write it into the requested
    # api url, pull in the key here, and check for it in the db, making sure that it was only
    # used once.  I'm going to hold off on doing this unless I start seeing lots of api requests
    # that look like people are hitting the url directly (without using the index).
  end

  def before_filter_get_url
    @api_url = RequestLib.server_name(request) + request.path
  end

  def before_filter_load_default_settings
    if StringLib.empty?(@settings[:map]): @settings[:map] = Constant::get(:default_map_id) end
    if StringLib.empty?(@settings[:lat])
      cur_loc = IpGeocoder.geocode(request.remote_ip)
      if (cur_loc == nil) or (cur_loc.lat == nil)
        @settings[:lat] = Constant::get(:default_lat)
        @settings[:lng] = Constant::get(:default_lng)
      else
        @settings[:lat] = cur_loc.lat
        @settings[:lng] = cur_loc.lng
        if StringLib.empty?(@settings[:zoom]): @settings[:zoom] = Constant::get(:default_zoom_found) end
      end
    end
    if StringLib.empty?(@settings[:zoom]): @settings[:zoom] = Constant::get(:default_zoom) end
    if StringLib.empty?(@settings[:controls]): @settings[:controls] = :all
    else @settings[:controls] = @settings[:controls].to_sym end
    if StringLib.empty?(@settings[:position])
      @settings[:position] = 'se'
    else
      @settings[:position].downcase!
      case @settings[:position]
        when 'ne', 'se', 'sw', 'nw'
        else
          @settings[:position] = 'se'
      end
    end
  end

  def before_filter_load_settings
    # Detect the requested settings
    @settings = {}
    unless (params[:settings] == nil) or (params[:settings] == "")
      arr = params[:settings].split('/')
      arr.each do | setting |
        arrTemp = setting.split('-')
        @settings[arrTemp.shift.to_sym] = arrTemp.join('-') 
      end
    end
  end

  def before_filter_load_version
    # Detect the requested version
    @version = Constant::get(:current_version).to_s
    unless (params[:version] == nil) or (params[:version] == ""): @version = StringLib.right(params[:version], params[:version].length - 1) end
  end

  def before_filter_map_action_to_version
    params[:version] = params[:action]
  end

  def after_filter_track_api_request(is_valid = true)
    ApiLog.create(:api_url => @api_url, :valid_url => is_valid, :requesting_url => params[:href], :requesting_host => params[:host], :ip_address => request.remote_ip)
  end
end
