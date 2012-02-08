require "swiss_knife/rspec/have_text"

describe "have_text matcher" do
  include SwissKnife::RSpec::Matchers

  it "should match string" do
    "abc".should have_text("abc")
  end

  it "should match regexp" do
    "abc".should have_text(/b/)
  end

  it "should not match string" do
    "abc".should_not have_text("d")
  end

  it "should not match regexp" do
    "abc".should_not have_text(/d/)
  end
end
