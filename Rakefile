require "rspec/core/rake_task"
require "./lib/swiss_knife/version"

RSpec::Core::RakeTask.new

begin
  require "jeweler"

  JEWEL = Jeweler::Tasks.new do |gem|
    gem.name = "swiss_knife"
    gem.version = SwissKnife::Version::STRING
    gem.summary = "Several helpers for Rails 3"
    gem.description = "Several helpers for Rails 3"
    gem.authors = ["Nando Vieira"]
    gem.email = "fnando.vieira@gmail.com"
    gem.homepage = "http://github.com/fnando/swiss_knife"
    gem.has_rdoc = true
    gem.add_dependency "rails", ">= 3.0.0"
    gem.add_development_dependency "rspec", ">= 2.0.0"
    gem.files = FileList["{Gemfile,Gemfile.lock,Rakefile,README.*,swiss_knife.gemspec}", "{spec,lib,locales}/**/*"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError => e
  puts "You don't Jeweler installed, so you won't be able to build gems."
end
