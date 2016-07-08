ENV["RAILS_ENV"] = "test"
ENV["DATABASE_URL"] = "sqlite3::memory:"
require "bundler/setup"
require "rails"
require_relative "./support/app"
require "ostruct"
require "swiss_knife"
require "rspec/rails"
require "swiss_knife/rspec"
require "fakeweb"
require "nokogiri"

FakeWeb.allow_net_connect = false

# Load support files
Dir[File.dirname(__FILE__) + "/support/rspec/**/*.rb"].each {|file| require file}

# Load database schema
load File.dirname(__FILE__) + "/schema.rb"

# Restore default configuration
RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.around do |example|
    Dir[Rails.root.join("public/javascripts/*.js")].each {|file| File.unlink(file)}
    Dir[Rails.root.join("public/stylesheets/*.css")].each {|file| File.unlink(file)}
    Dir[File.dirname(__FILE__) + "/resources/**/*_packaged.**"].each {|file| File.unlink(file)}

    example.call
  end
end
