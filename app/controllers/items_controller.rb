class ItemsController < ApplicationController
  include StringLib
   before_filter :before_filter_get_geo_point

   def new
      @item = Item.new
   end

   def create
      unless params[:item] == nil
        if (params[:item][:data_type_id].to_i == Constant::get(:data_type_url))
          # Clean up URLs.  I did this because they come in with http:// and trailing / from the xdcomm submit.
          unless StringLib.url_has_protocol(params[:item][:value]): params[:item][:value] = 'http://' + params[:item][:value] end
          StringLib.trim!(params[:item][:value], '/')
          params[:item][:value] = params[:item][:value] + '/'
        end
         @item = Item.find_by_value_sanitized(params[:item][:value])
         if @item == nil
            @item = Item.create(params[:item])
         else
            if @item.title == nil or @item.title == ""
               @item.title = params[:item][:title]
            end
            if @item.data_type_id == nil or @item.data_type_id == 0 or @item.data_type_id == Constant::get(:data_type_unknown)
               @item.data_type_id = params[:item][:data_type_id]
            end
            @item.save
         end
      end
      if @item.geo_points.find_by_lat_and_lng(@geo_point.lat, @geo_point.lng) == nil
         @item.geo_points << @geo_point
      end
      redirect_to geo_point_path(@geo_point.lat, @geo_point.lng)
   end
end
