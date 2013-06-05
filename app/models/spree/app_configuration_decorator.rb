Spree::AppConfiguration.class_eval do
  preference :store_id, :string
  preference :pro_api_key, :string
  preference :pro_url, :string, :default => 'http://aug-stg1.spree.mx'
end
