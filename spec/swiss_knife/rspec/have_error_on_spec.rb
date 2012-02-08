require "swiss_knife/rspec/have_error_on"

describe "have_error_on matcher" do
  include SwissKnife::RSpec::Matchers

  it "detects errors" do
    record = mock(:errors => {:name => ["some error"]})
    record.should have_error_on(:name)
  end

  it "detects when record has no errors" do
    record = mock(:errors => {:name => []})
    record.should_not have_error_on(:name)
  end

  it "detects errors with alias" do
    record = mock(:errors => {:name => [1,2]})
    record.should have_errors_on(:name)
  end

  it "throws message for positive failure" do
    record = mock(:errors => {:name => []})

    expect {
      record.should have_errors_on(:name)
    }.to raise_error(/to have errors on :name/)
  end

  it "throws message for negative failure" do
    record = mock(:errors => {:name => [1]})

    expect {
      record.should_not have_errors_on(:name)
    }.to raise_error(/to have no errors on :name/)
  end
end
