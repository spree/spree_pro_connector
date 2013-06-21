Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :orders do
      resources :events, :only => :index
    end

    match 'integration' => 'integration#show'
    match 'integration/register' => 'integration#register'
    match 'integration/connect' => 'integration#connect'
    match 'integration/disconnect' => 'integration#disconnect'
    match 'integration/*backbone' => 'integration#show'

    get 'endpoint_testing', to: redirect("/admin/endpoint_messages/new")

    resources :endpoint_messages, except: [:show, :destroy]
  end

  namespace :api, :defaults => { :format => 'json' } do
    get :integrator, :to => 'integrator#index'
  end
end

