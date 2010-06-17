ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :user_sessions
  map.resources :pages, :member => {:versions => :get} do |page|
    page.resources :versions, :only => [:index, :show]
  end

  map.root :controller => 'dashboards', :action => 'show'
  map.resource :dashboard, :only => :show
end

