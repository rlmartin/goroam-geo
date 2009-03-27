ActionController::Routing::Routes.draw do |map|
  @reAny = /.+/
  @reDecimal = /-?[\d]{0,5}(\.\d+)?/
  @reDistUnits = /(km|kilometer|kilometers|kms|mi|mile|mis|miles|ms|meters|m|meter|yds|yards|yd|yard|ft|feet|foot)?/
  @reInt = /\d+/
  @reRange = /(to|-)/
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "general_page"

  # See how all your routes lay out with "rake routes"

  # Routes for GeoPoints
  # Routes to add new items to a GeoPoint
  map.create_item ':lat/:lng', :action => "create", :controller => "items", :requirements => { :lat => @reDecimal, :lng => @reDecimal }, :conditions => { :method => :post }
  map.connect ':lat/:lng.:format', :action => "create", :controller => "items", :requirements => { :lat => @reDecimal, :lng => @reDecimal }, :conditions => { :method => :post }
  # Route to display the form to add new items to a GeoPoint
  map.new_item ':lat/:lng/new', :action => "new", :controller => "items", :requirements => { :lat => @reDecimal, :lng => @reDecimal }
  # Main routes for viewing a GeoPoint, with or without data formatting
  map.geo_point ':lat/:lng', :controller => "geo_points", :requirements => { :lat => @reDecimal, :lng => @reDecimal }
  map.connect ':lat/:lng.:format', :controller => "geo_points", :requirements => { :lat => @reDecimal, :lng => @reDecimal }
  # Routes to view a GeoPoint, limiting the number of results
  map.connect ':lat/:lng/limit/:limit', :controller => "geo_points", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :limit => @reInt }
  map.connect ':lat/:lng/limit/:limit.:format', :controller => "geo_points", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :limit => @reInt }
  map.connect ':lat/:lng/limit/:limit:to:ulimit', :controller => "geo_points", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :limit => @reInt, :to => @reRange, :ulimit => @reInt }
  map.connect ':lat/:lng/limit/:limit:to:ulimit.:format', :controller => "geo_points", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :limit => @reInt, :to => @reRange, :ulimit => @reInt }
  # Main routes for viewing a GeoPoint and items within a certain range, with or without data formatting
  map.connect ':lat/:lng/:within:units', :controller => "geo_points", :action => "find_within", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :within => @reDecimal, :units => @reDistUnits }
  map.connect ':lat/:lng/:within:units.:format', :controller => "geo_points", :action => "find_within", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :within => @reDecimal, :units => @reDistUnits }
  # Routes to view a GeoPoint and items within a certain range, limiting the number of results
  map.connect ':lat/:lng/:within:units/limit/:limit', :controller => "geo_points", :action => "find_within", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :limit => @reInt, :within => @reDecimal, :units => @reDistUnits }
  map.connect ':lat/:lng/:within:units/limit/:limit.:format', :controller => "geo_points", :action => "find_within", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :limit => @reInt, :within => @reDecimal, :units => @reDistUnits }
  map.connect ':lat/:lng/:within:units/limit/:limit:to:ulimit', :controller => "geo_points", :action => "find_within", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :limit => @reInt, :to => @reRange, :ulimit => @reInt, :within => @reDecimal, :units => @reDistUnits }
  map.connect ':lat/:lng/:within:units/limit/:limit:to:ulimit.:format', :controller => "geo_points", :action => "find_within", :requirements => { :lat => @reDecimal, :lng => @reDecimal, :limit => @reInt, :to => @reRange, :ulimit => @reInt, :within => @reDecimal, :units => @reDistUnits }

  # Routes to access the public API
  map.connect 'api/xdcomm.js', :controller => "api", :action => "xdcomm", :format => "js"
  map.connect 'api/:version/:settings.js', :controller => "api", :format => "js", :requirements => { :version => /v[^\/]+/, :settings => @reAny }
  map.connect 'api/:version.js', :controller => "api", :format => "js", :requirements => { :version => /v[^\/]+/ }
  map.connect 'api/:settings.js', :controller => "api", :format => "js", :requirements => { :settings => @reAny }
  map.connect 'api.js', :controller => "api", :format => "js"
  map.connect 'api_/:action/:settings.js', :controller => "api", :format => "js", :requirements => { :action => /v[^\/]+/, :settings => @reAny }
  map.connect 'api_/:action.js', :controller => "api", :format => "js"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'

  # Routes to static pages.
  map.connect 'search', :controller => "general_page", :action => "search"
  map.connect 'howto', :controller => "general_page", :action => "howto"
  map.connect ':action', :controller => "general_page", :requirements => { :action => /step[123]/ }

  # This catches all unrecognized urls and shows an error page.  Maybe there's some other way of doing this
  # with RoR settings or something, but this works for now.
  map.connect ':path.:format', :controller => "general_page", :action => "page_not_found", :requirements => { :path => /.*/ }
  map.connect ':path', :controller => "general_page", :action => "page_not_found", :requirements => { :path => /.*/ }
end
