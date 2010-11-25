ENV["RAILS_ENV"] = "test"
require "rails"
require "ostruct"
require "swiss_knife"
require File.dirname(__FILE__) + "/support/config/boot"
require "rspec/rails"
require "swiss_knife/rspec"

FakeWeb.allow_net_connect = false

# Load support files
Dir[File.dirname(__FILE__) + "/support/rspec/**/*.rb"].each {|file| require file}

# Restore default configuration
RSpec.configure do |config|
  remote_static_files = proc do
    Dir[Rails.root.join("public/javascripts/*.js")].each {|file| File.unlink(file)}
    Dir[Rails.root.join("public/stylesheets/*.css")].each {|file| File.unlink(file)}
    Dir[File.dirname(__FILE__) + "/resources/**/*_packaged.**"].each {|file| File.unlink(file)}
  end

  config.before(&remote_static_files)
  config.after(&remote_static_files)
end
