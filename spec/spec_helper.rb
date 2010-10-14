ENV["RAILS_ENV"] = "test"
require "rails"
require "swiss_knife"
require File.dirname(__FILE__) + "/support/config/boot"
require "rspec/rails"
require "swiss_knife/rspec"

FakeWeb.allow_net_connect = false

# Load support files
Dir[File.dirname(__FILE__) + "/support/rspec/**/*.rb"].each {|file| require file}

# Restore default configuration
RSpec.configure do |config|
  remove_file = proc do |file|
    File.unlink(file)
  end

  remote_static_files = proc do
    Dir[Rails.root.join("public/javascripts/*.js")].each(&remove_file)
    Dir[Rails.root.join("public/stylesheets/*.css")].each(&remove_file)
    Dir[File.dirname(__FILE__) + "/resources/**/*_packaged.**"].each(&remove_file)
  end

  config.before(&remote_static_files)
  config.after(&remote_static_files)
end
