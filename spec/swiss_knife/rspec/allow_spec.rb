require "spec_helper"

describe "allow matcher" do
  it "allows blank values" do
    klass = Class.new(ActiveRecord::Base) do
      table_name "users"
    end

    record = klass.new
    record.should allow_values(nil, "").as(:name)
  end

  it "requires name to be set" do
    klass = Class.new(ActiveRecord::Base) do
      table_name "users"
      validates_presence_of :name
    end

    record = klass.new
    record.should_not allow_values(nil, "").as(:name)
  end

  it "allows values" do
    klass = Class.new(ActiveRecord::Base) do
      table_name "users"
    end

    record = klass.new
    record.should allow_values("John Doe", "Jane Doe").as(:name)
  end
end
