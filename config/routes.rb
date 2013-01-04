Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :orders do
      resources :events, :only => :index
    end
  end
end
