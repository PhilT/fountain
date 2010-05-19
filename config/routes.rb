ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :user_sessions
  map.resources :pages

  map.root :controller => 'dashboards', :action => 'show'
  map.resource :dashboard, :only => :show
end

