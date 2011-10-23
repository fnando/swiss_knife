require "spec_helper"

describe ApplicationController do
  before do
    controller.stub :controller_name => "products"
  end

  it "should return inline title" do
    controller.page_title "Viewing all products"
    controller.page_title.should == "Viewing all products"
  end

  it "should return internationalized title" do
    controller.stub :action_name => "index"
    controller.page_title.should == "All products"
  end

  it "should store interpolation options" do
    controller.page_title :name => "Some product"
    controller.page_title_options.should == {:name => "Some product"}
  end

  it "should return internationalized title with interpolation options" do
    controller.page_title :name => "Some product"
    controller.stub :action_name => "edit"
    controller.page_title.should == "Editing Some product"
  end

  it "should return missing translation" do
    controller.stub :action_name => "details"

    expect {
      controller.page_title.should match(/translation missing/)
    }.to_not raise_error
  end

  it "should alias create action" do
    controller.stub :action_name => "create"
    controller.page_title.should == "Add a new product"
  end

  it "should alias update action" do
    controller.page_title :name => "Some product"
    controller.stub :action_name => "update"
    controller.page_title.should == "Editing Some product"
  end

  it "should alias remove action" do
    controller.page_title :name => "Some product"
    controller.stub :action_name => "remove"
    controller.page_title.should == "Remove Some product"
  end

  it "should be added as a helper method" do
    ApplicationController._helper_methods.should include(:page_title)
  end
end
