require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'spree/testing_support/extension_rake'
require 'json'
require 'samples/vpd'
require 'httparty'

RSpec::Core::RakeTask.new

task :default => [:spec]

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree_pro_connector'
  Rake::Task['extension:test_app'].invoke
end

desc 'Generates sample data for VPD endpoint'
task :vpd_data do
  size = ENV.fetch('size', 1).to_i

  url = 'http://srv.vpdinc.com/dev/devr.wsc/service/spree_order.p'
  # url = 'http://requestb.in/14jfman1'
  puts "API URL = #{url}"

  (1..size).each do |i|
    puts "\n--------VPD DATA #{i}-------------\n"
    res = HTTParty.post(url,
                  body: Samples::VPD.ready.to_json,
                  headers: { 'X-Augury-Token' => '123123123123123123123',
                             'Content-Type' => 'application/json' })
    puts res
  end
end

