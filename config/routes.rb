Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :orders do
      resources :events, :only => :index
    end

    resource :integration
  end

  namespace :api, :defaults => { :format => 'json' } do
    get :integrator, :to => 'integrator#index'
  end
end
