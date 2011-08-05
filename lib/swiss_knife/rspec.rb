require "swiss_knife/rspec/have_tag"
require "swiss_knife/rspec/have_text"
require "swiss_knife/rspec/allow"

RSpec.configure do |config|
  config.include(SwissKnife::RSpec::Matchers)
end
