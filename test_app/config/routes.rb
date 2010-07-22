ActionController::Routing::Routes.draw do |map|
  map.broken '/broken', :controller => 'pages', :action => 'broken'
  map.root              :controller => 'pages', :action => 'index'
end
