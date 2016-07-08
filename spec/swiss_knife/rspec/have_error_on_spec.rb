require "swiss_knife/rspec/have_error_on"

describe "have_error_on matcher" do
  include SwissKnife::RSpec::Matchers

  it "detects errors" do
    record = double(:errors => {:name => ["some error"]})
    expect(record).to have_error_on(:name)
  end

  it "detects when record has no errors" do
    record = double(:errors => {:name => []})
    expect(record).not_to have_error_on(:name)
  end

  it "detects errors with alias" do
    record = double(:errors => {:name => [1,2]})
    expect(record).to have_errors_on(:name)
  end

  it "throws message for positive failure" do
    record = double(:errors => {:name => []})

    expect {
      expect(record).to have_errors_on(:name)
    }.to raise_error(/to have errors on :name/)
  end

  it "throws message for negative failure" do
    record = double(:errors => {:name => [1]})

    expect {
      expect(record).not_to have_errors_on(:name)
    }.to raise_error(/to have no errors on :name/)
  end
end
