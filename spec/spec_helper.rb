# Load application RSpec helper
begin
  require File.dirname(__FILE__) + "/../../../../spec/spec_helper"
rescue LoadError
  puts "Your application hasn't been bootstraped with RSpec.\nI'll do it on my own!\n\n"
  system "cd '#{File.dirname(__FILE__) + "/../../../../"}' && script/generate rspec"
  puts "\n\nRun `rake spec` again."
  exit
end

# Establish connection with in memory SQLite 3 database
ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

# Set locale
I18n.locale = :en

# I18n additionals files
I18n.load_path += Dir[File.dirname(__FILE__) + "/resources/**/*.yml"]
::I18n.backend.__send__ :init_translations

# Load database schema
load File.dirname(__FILE__) + "/schema.rb"

# Create an alias for lambda
alias :doing :lambda

Spec::Runner.configure do |config|
  config.before(:each) do
    `rm -rf #{File.dirname(__FILE__) + "/tmp"}`
    `mkdir #{File.dirname(__FILE__) + "/tmp"}`
  end
end
