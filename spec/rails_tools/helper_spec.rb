require File.dirname(__FILE__) + "/../spec_helper"

describe RailsTools::Helper, :type => :helper do
  before do
    @controller = helper.send(:controller)
    @controller.stub!(:controller_name => "sample", :action_name => "index")
    helper.stub!(:controller).and_return(@controller)
    helper.output_buffer = ""
  end

  describe "flash_messages" do
    subject { helper.flash_messages }

    before do
      flash[:notice] = "Notice"
      flash[:warning] = "Warning"
      flash[:error] = "Error"
    end

    it "should render multiple flash messages" do
      subject.should have_tag("p.message", :count => 3)
    end

    it "should render error message" do
      subject.should have_tag("p.error", "Error")
    end

    it "should render warning message" do
      subject.should have_tag("p.warning", "Warning")
    end

    it "should render notice message" do
      subject.should have_tag("p.notice", "Notice")
    end
  end

  describe "block wrappers" do
    context "body" do
      it "should use defaults" do
        html = helper.body { "Body" }

        html.should have_tag("body", :count => 1)
        html.should have_tag("body#sample-page")
        html.should have_tag("body.sample-index")
        html.should have_tag("body.en")
      end

      it "should use alias for action" do
        @controller.stub!(:action_name).and_return("create")
        helper.body { "Body" }.should have_tag("body.sample-new")

        @controller.stub!(:action_name).and_return("update")
        helper.body { "Body" }.should have_tag("body.sample-edit")

        @controller.stub!(:action_name).and_return("destroy")
        helper.body { "Body" }.should have_tag("body.sample-remove")
      end

      it "should use custom settings" do
        html = helper.body(:id => "page", :class => "dark", :onload => "init();") { "Body" }

        html.should have_tag("body#page")
        html.should have_tag("body.dark")
        html.should have_tag("body[onload=init();]")
      end
    end

    it "should wrap content into main div" do
      helper.main { "Main" }.should have_tag("div#main", "Main")
    end

    it "should wrap content into sidebar div" do
      helper.sidebar { "Sidebar" }.should have_tag("div#sidebar", "Sidebar")
    end

    it "should wrap content into footer div" do
      helper.footer { "Footer" }.should have_tag("div#footer", "Footer")
    end

    it "should wrap content into header div" do
      helper.header { "Header" }.should have_tag("div#header", "Header")
    end

    it "should use other options like css class" do
      helper.wrapper(:id => "header", :class => "rounded") { "Header" }.should have_tag("div#header.rounded", "Header")
    end
  end

  describe "rails meta tag" do
    it "should contain meta tags" do
      @controller.class.stub!(:name).and_return("SampleController")

      html = helper.rails_meta_tags
      html.should have_tag("meta", :count => 2)
      html.should have_tag("meta[name=rails-controller][content=sample]")
      html.should have_tag("meta[name=rails-action][content=index]")
    end

    it "should return normalized controller name for namespaced controller" do
      @controller.class.stub!(:name).and_return("Admin::SampleController")

      html = helper.rails_meta_tags
      html.should have_tag("meta[name=rails-controller][content=admin_sample]")
    end
  end

  describe "mail to" do
    before do
      @html = helper.mail_to("john@doe.com")
    end

    it "should be encrypted" do
      @html.should_not match(/john@doe\.com/)
      @html.should_not have_tag("a", "john@doe.com")
    end

    it "should not have plain-text protocol" do
      @html.should_not match(/mailto:/)
    end

    it "should use provided label" do
      helper.mail_to("john@doe.com", "john's email").should have_tag("a", "john's email")
    end
  end
end
