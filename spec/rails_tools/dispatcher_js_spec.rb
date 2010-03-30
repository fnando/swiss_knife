require "spec_helper"

describe RailsTools::DispatcherJs do
  before do
    @url = "http://github.com/fnando/dispatcher-js/raw/master/dispatcher.js"
    @destiny = File.dirname(__FILE__) + "/../tmp"
    @file = @destiny + "/dispatcher.js"
  end

  it "should update file" do
    @mock = mock("open-uri", :read => "DISPATCHER JS")
    RailsTools::DispatcherJs.should_receive(:open).with(@url).and_return(@mock)
    RailsTools::DispatcherJs.update(:to => @destiny)

    File.read(@file).should == "DISPATCHER JS"
  end

  it "should overwrite previous file" do
    File.open(@file, "w+") << "OLD DISPATCHER JS CONTENT"
    @mock = mock("open-uri", :read => "UPDATED DISPATCHER JS CONTENT")
    RailsTools::DispatcherJs.should_receive(:open).with(@url).and_return(@mock)
    RailsTools::DispatcherJs.update(:to => @destiny)

    File.read(@file).should == "UPDATED DISPATCHER JS CONTENT"
  end
end
