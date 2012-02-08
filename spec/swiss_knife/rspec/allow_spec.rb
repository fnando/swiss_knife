require "swiss_knife/rspec/allow"
require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

require File.expand_path("../../../schema", __FILE__)

describe "allow matcher" do
  include SwissKnife::RSpec::Matchers

  it "allows blank values" do
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = "users"
    end

    record = klass.new
    record.should allow(nil, "").as(:name)
  end

  it "requires name to be set" do
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = "users"
      validates_presence_of :name
    end

    klass.stub name: "User"

    record = klass.new
    record.should_not allow(nil, "").as(:name)
  end

  it "allows values" do
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = "users"
    end

    record = klass.new
    record.should allow("John Doe", "Jane Doe").as(:name)
  end
end
