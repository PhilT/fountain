ActionController::Routing::Routes.draw do |map|
  map.resources :pages
  map.resources :logins, :only => [:new, :create, :destroy]

  map.root :controller => 'pages', :action => 'show', :id => 'home-page'
end

