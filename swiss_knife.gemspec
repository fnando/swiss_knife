# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "swiss_knife/version"

Gem::Specification.new do |s|
  s.name        = "swiss_knife"
  s.version     = SwissKnife::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["fnando.vieira@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/swiss_knife"
  s.summary     = "Several helpers for Rails 3"
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 3.0.0"
  s.add_development_dependency "rspec-rails", "~> 2.5.0"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "sqlite3"
end
