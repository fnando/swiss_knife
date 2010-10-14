require "spec_helper"

describe SwissKnife::RSpec::Matchers::HaveText do
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
