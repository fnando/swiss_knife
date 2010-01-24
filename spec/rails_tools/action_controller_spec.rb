require File.dirname(__FILE__) + "/../spec_helper"

class SampleController < ApplicationController
  def index; render :text => "index"; end
end

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

  describe "less" do
    it "should generate css on before filter" do
      # Set source and destiny paths
      options = {
        :from => File.join(Rails.root, "app", "stylesheets"),
        :to   => File.join(Rails.root, "public", "stylesheets")
      }

      # This filter is added on init.rb only on development environment.
      SampleController.before_filter :generate_css_from_less
      RailsTools::Less.should_receive(:export).with(options)

      get :index
    end
  end
end
