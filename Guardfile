require 'sprockets'

guard 'coffeescript', :input => 'spec/javascripts/coffeescripts', :output => 'spec/javascripts/compiled'

guard 'sprockets', :destination => 'public/javascripts', :asset_paths => ['app/assets/javascripts/admin', 'vendor/assets/javascripts'], :minify => true do
  watch 'app/assets/javascripts/admin/spree_pro_connector.js'
end
