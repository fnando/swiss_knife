require "swiss_knife/rspec/have_tag"

RSpec.configure {|config| config.include(SwissKnife::RSpec::Matchers)} if defined?(RSpec)
