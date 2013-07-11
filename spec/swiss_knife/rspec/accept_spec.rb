require "swiss_knife/rspec/accept"
require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

require File.expand_path("../../../schema", __FILE__)

describe "accept matcher" do
  include SwissKnife::RSpec::Matchers

  it "accepts blank values" do
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = "users"
    end

    record = klass.new
    record.should accept(nil, "").for(:name)
  end

  it "requires name to be set" do
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = "users"
      validates_presence_of :name
    end

    klass.stub name: "User"

    record = klass.new
    record.should_not accept(nil, "").for(:name)
  end

  it "accepts values" do
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = "users"
    end

    record = klass.new
    record.should accept("John Doe", "Jane Doe").for(:name)
  end
end
