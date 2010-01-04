require File.dirname(__FILE__) + "/../spec_helper"

class SampleController < ActionController::Base; end

describe RailsTools::ActionController, :type => :controller do
  controller_name :sample

  describe "page title" do
    it "should set page title" do
      controller.send(:set_page_title, "My page title")
      controller.send(:page_title).should == "My page title"
    end

    it "should use default title" do
      controller.stub!(:action_name).and_return("create")
      controller.send(:page_title).should == "Sample Create"
    end

    it "should use scoped title" do
      controller.stub!(:action_name).and_return("index")

      controller.send(:page_title).should == "My sample index"
    end

    it "should use scoped title with interpolation" do
      controller.stub!(:action_name).and_return("show")
      controller.send(:set_page_title, nil, :name => "John")

      controller.send(:page_title).should == "John's page"
    end
  end
end
