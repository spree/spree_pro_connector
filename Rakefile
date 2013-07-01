require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'spree/testing_support/extension_rake'
require 'logger'
require 'sprockets'

RSpec::Core::RakeTask.new

task :default => [:spec]

desc 'Generates a dummy app for testing'
task :test_app do
    ENV['LIB_NAME'] = 'spree_pro_connector'
      Rake::Task['extension:test_app'].invoke
end

namespace :assets do
  ROOT = Pathname.new(File.dirname(__FILE__))
  logger = Logger.new(STDOUT)
  APP_ASSETS_DIR = ROOT.join("app/assets")
  PUBLIC_ASSETS_DIR = ROOT.join("vendor/assets")
  BUILD_DIR = ROOT.join("build")

  desc 'Compile assets'
  task :compile => :compile_js

  desc 'Compile javascript'
  task :compile_js do
  outfile = Pathname.new(BUILD_DIR).join('application.min.js')

    sprockets = Sprockets::Environment.new(ROOT) do |env|
      env.logger = logger
    end

    sprockets.append_path(APP_ASSETS_DIR.join('javascripts/admin').to_s)
    sprockets.append_path(PUBLIC_ASSETS_DIR.join('javascripts').to_s)

    FileUtils.mkdir_p outfile.dirname
    asset = sprockets['spree_pro_connector.js']
    asset.write_to(outfile)
    puts "Compiled JS assets"
  end
end
