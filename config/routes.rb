ActionController::Routing::Routes.draw do |map|
  map.resources :pages

  map.root :controller => 'pages', :action => 'show', :id => 'home-page'
end

