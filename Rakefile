require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'spree/testing_support/extension_rake'
require 'json'
require 'samples/vpd'

RSpec::Core::RakeTask.new

task :default => [:spec]

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree_pro_connector'
  Rake::Task['extension:test_app'].invoke
end

desc 'Generates sample data for VPD endpoint'
task :vpd_data do
  size = (ENV['size'] || 1).to_i
  (1..size).each do |i|
    puts "\n--------VPD DATA #{i}-------------\n"
    puts JSON.pretty_generate(Samples::VPD.ready)
  end
end

