require "swiss_knife/rspec/have_text"

describe "have_text matcher" do
  include SwissKnife::RSpec::Matchers

  it "should match string" do
    expect("abc").to have_text("abc")
  end

  it "should match regexp" do
    expect("abc").to have_text(/b/)
  end

  it "should not match string" do
    expect("abc").not_to have_text("d")
  end

  it "should not match regexp" do
    expect("abc").not_to have_text(/d/)
  end
end
