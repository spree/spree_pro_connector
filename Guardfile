require 'sprockets'

guard 'coffeescript', :input => 'spec/javascripts/coffeescripts', :output => 'spec/javascripts/compiled', :all_on_start => true

guard 'sprockets', :destination => 'public/javascripts', :asset_paths => ['app/assets/javascripts/admin', 'vendor/assets/javascripts'], 
  :root_file => 'app/assets/javascripts/admin/spree_pro_connector.js', :minify => true do
  watch(%r{^app/assets/javascripts/admin/(.+)\.(js|js\.coffee)})
end
