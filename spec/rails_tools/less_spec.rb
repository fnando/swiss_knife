require File.dirname(__FILE__) + "/../spec_helper"

require "less"

describe RailsTools::Less do
  before do
    @source = File.dirname(__FILE__) + "/../resources/stylesheets"
    @destiny = File.dirname(__FILE__) + "/../tmp"
    RailsTools::Less.export(:from => @source, :to => @destiny)
  end

  it "should ignore partial files" do
    File.should_not be_file(@destiny + "/_shared.css")
  end

  it "should generate stylesheets" do
    File.should be_file(@destiny + "/main.css")
    File.should be_file(@destiny + "/ui/window.css")
  end

  it "should import partial" do
    File.read(@destiny + "/main.css").should match(/\* \{ background: #ffffff; \}/)
  end

  it "should copy files with .css extension" do
    File.should be_file(@destiny + "/reset.css")
    File.should be_file(@destiny + "/ui/tab.css")
  end
end