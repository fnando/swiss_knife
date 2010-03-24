require "spec_helper"

module SampleHelper
  def self.helper_method(*attrs); end
  include RailsTools::ActionController::InstanceMethods
end

describe SampleHelper, :type => :helper do
  describe "page title's sanity check" do
    it "should respond to the helper methods" do
      helper.send(:set_page_title, "My page title")
      helper.send(:page_title).should == "My page title"
    end
  end
end
