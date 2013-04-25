Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :orders do
      resources :events, :only => :index
    end
  end

  namespace :api, :defaults => { :format => 'json' } do
    get :integrator, :to => 'integrator#index'
    post 'integrator/add_stock', :to => 'integrator#add_stock'
  end
end
