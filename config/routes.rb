ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :user_sessions
  map.resources :pages

  map.root :controller => 'pages', :action => 'show', :id => 'home-page'
end

