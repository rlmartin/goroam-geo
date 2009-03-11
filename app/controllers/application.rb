# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :before_filter_init_page

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '56e629d324ed07b5ec2f58ad73f74f3b'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  protected
  def before_filter_detect_item_search_constraints
    lower_limit = (params[:limit] || 0).to_i
    upper_limit = (params[:ulimit] || 0).to_i
    if upper_limit.to_i <= 0
      @limit = lower_limit
      if @limit <= 0: @limit = Constant::get(:default_item_display_limit) end
      @offset = 0
    else
      @offset = lower_limit.to_i - 1
      if @offset <= 0: @offset = 0 end
      @limit = upper_limit.to_i - @offset
    end
  end

  def before_filter_get_geo_point
    lat = params[:lat].to_d.round(Constant::get(:lat_lng_precision))
    lng = params[:lng].to_d.round(Constant::get(:lat_lng_precision))
    # I could do this (below), but I like the forced ordering.  Maybe it's overkill.
    # @geo_point = GeoPoint.find_or_create_by_lat_and_lng(@lat, @lng)
    @geo_point = GeoPoint.find_last_by_lat_and_lng(lat, lng, :order => "id DESC")
    if @geo_point == nil: @geo_point = GeoPoint.create(:lat => lat, :lng => lng) end
  end

  def before_filter_init_page
    @page = { :description => "", :keywords => "", :main_class => "", :title => "" }
  end
end
