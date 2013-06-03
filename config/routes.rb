Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :orders do
      resources :events, :only => :index
    end

    match 'integration' => 'integration#show'
    match 'integration/register' => 'integration#register'
  end

  namespace :api, :defaults => { :format => 'json' } do
    get :integrator, :to => 'integrator#index'
  end
end
