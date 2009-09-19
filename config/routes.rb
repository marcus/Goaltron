ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  #Restful authentication
  map.connect 'journal/list', :controller => 'journal_entries', :action => 'list'
  map.connect 'journal_entries/list', :controller => 'journal_entries', :action => 'list'
  map.resources :users, :sessions, :journal_entries
  map.connect '', :controller => 'default', :action => 'index'
  map.connect 'daily', :controller => 'daily_day_entries', :action => 'index'
  map.connect 'daily/list', :controller => 'daily_goals', :action => 'list'
  map.connect 'daily/history', :controller => 'daily_day_entries', :action => 'history'
  map.connect 'journal', :controller => 'journal_entries', :action => 'index'
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
