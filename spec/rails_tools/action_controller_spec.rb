require "spec_helper"

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
      controller.stub!(:action_name).and_return("profile")
      controller.send(:page_title).should == "Sample Profile"
    end

    it "should use scoped title" do
      translations :index => "My sample index"
      controller.stub!(:action_name).and_return("index")

      controller.send(:page_title).should == "My sample index"
    end

    it "should use scoped title with interpolation" do
      translations :show => "{{name}}'s page"
      controller.stub!(:action_name).and_return("show")
      controller.send(:set_page_title, nil, :name => "John")

      controller.send(:page_title).should == "John's page"
    end

    it "should not return aliased title for create action" do
      translations :create => "My create page"
      controller.stub!(:action_name).and_return("create")

      controller.send(:page_title).should == "My create page"
    end

    it "should return aliased title for create action" do
      translations :new => "My new page"
      controller.stub!(:action_name).and_return("create")

      controller.send(:page_title).should == "My new page"
    end

    it "should not return aliased title for update action" do
      translations :update => "My update page"
      controller.stub!(:action_name).and_return("update")

      controller.send(:page_title).should == "My update page"
    end

    it "should return aliased title for update action" do
      translations :edit => "My edit page"
      controller.stub!(:action_name).and_return("update")

      controller.send(:page_title).should == "My edit page"
    end

    it "should not return aliased title for remove action" do
      translations :remove => "My remove page"
      controller.stub!(:action_name).and_return("remove")

      controller.send(:page_title).should == "My remove page"
    end

    it "should return aliased title for update action" do
      translations :destroy => "My destroy page"
      controller.stub!(:action_name).and_return("remove")

      controller.send(:page_title).should == "My destroy page"
    end

    def translations(messages)
      I18n.backend.stub!(:translations).and_return(HashWithIndifferentAccess.new(:en => {:titles => {:sample => messages}}))
    end
  end

  describe "less" do
    it "should generate css on before filter" do
      # Set source and destiny paths
      options = {
        :from => File.join(::Rails.root, "app", "stylesheets"),
        :to   => File.join(::Rails.root, "public", "stylesheets")
      }

      # This filter is added on init.rb only on development environment.
      SampleController.before_filter :generate_css_from_less
      RailsTools::Less.should_receive(:export).with(options)

      get :index
    end
  end

  describe "i18n-js" do
    it "should generate messages on before filter" do
      # This filter is added on init.rb only on development environment.
      SampleController.before_filter :generate_i18n_js
      SimplesIdeias::I18n.should_receive(:export!)

      get :index
    end
  end
end
