Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :orders do
      resources :events, :only => :index
    end

    match 'integration' => 'integration#show'
    match 'integration/register' => 'integration#register'
    match 'integration/*backbone' => 'integration#show'

    get  "endpoint_testing"  => "endpoint_testing#new",    as: :endpoint_testing
    post "endpoint_testing"  => "endpoint_testing#create", as: :endpoint_testing
    put  "endpoint_testing"  => "endpoint_testing#create", as: :endpoint_testing
    get  "endpoint_testings" => "endpoint_testing#index",  as: :endpoint_testings
  end

  namespace :api, :defaults => { :format => 'json' } do
    get :integrator, :to => 'integrator#index'
  end
end

