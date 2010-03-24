require "spec_helper"

describe RailsTools::RailsJs do
  before do
    @destiny = File.dirname(__FILE__) + "/../tmp"
    @file = @destiny + "/rails.min.js"
  end

  it "should update file" do
    @mock = mock("open-uri", :read => "RAILS JS")
    RailsTools::RailsJs.should_receive(:open).with("http://github.com/fnando/rails-js/raw/master/rails.min.js").and_return(@mock)
    RailsTools::RailsJs.update(:to => @destiny)

    File.read(@file).should == "RAILS JS"
  end

  it "should overwrite previous file" do
    File.open(@file, "w+") << "OLD RAILS JS CONTENT"
    @mock = mock("open-uri", :read => "UPDATED RAILS JS CONTENT")
    RailsTools::RailsJs.should_receive(:open).with("http://github.com/fnando/rails-js/raw/master/rails.min.js").and_return(@mock)
    RailsTools::RailsJs.update(:to => @destiny)

    File.read(@file).should == "UPDATED RAILS JS CONTENT"
  end
end
