require "swiss_knife/rspec/have_tag"
require "swiss_knife/rspec/have_text"
require "swiss_knife/rspec/allow"

RSpec.configure {|config| config.include(SwissKnife::RSpec::Matchers)} if defined?(RSpec)
