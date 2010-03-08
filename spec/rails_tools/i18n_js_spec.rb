require File.dirname(__FILE__) + "/../spec_helper"

describe RailsTools::I18nJs do
  before do
    @destiny = File.dirname(__FILE__) + "/../tmp"
    @file = @destiny + "/i18n.js"
  end

  it "should update file" do
    @mock = mock("open-uri", :read => "I18N JS")
    RailsTools::I18nJs.should_receive(:open).with("http://github.com/fnando/i18n-js/raw/master/lib/i18n.js").and_return(@mock)
    RailsTools::I18nJs.update(:to => @destiny)

    File.read(@file).should == "I18N JS"
  end

  it "should overwrite previous file" do
    File.open(@file, "w+") << "OLD I18N JS CONTENT"
    @mock = mock("open-uri", :read => "UPDATED I18N JS CONTENT")
    RailsTools::I18nJs.should_receive(:open).with("http://github.com/fnando/i18n-js/raw/master/lib/i18n.js").and_return(@mock)
    RailsTools::I18nJs.update(:to => @destiny)

    File.read(@file).should == "UPDATED I18N JS CONTENT"
  end
end
