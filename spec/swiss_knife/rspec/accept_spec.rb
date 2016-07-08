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
    expect(record).to accept(nil, "").for(:name)
  end

  it "requires name to be set" do
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = "users"
      validates_presence_of :name
    end

    allow(klass).to receive_messages name: "User"

    record = klass.new
    expect(record).not_to accept(nil, "").for(:name)
  end

  it "accepts values" do
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = "users"
    end

    record = klass.new
    expect(record).to accept("John Doe", "Jane Doe").for(:name)
  end
end
