require "spec_helper"

describe RailsTools::Helper, :type => :helper do
  before do
    I18n.locale = :en
    @controller = helper.send(:controller)
    @controller.stub!(:controller_name => "sample", :action_name => "index")
    helper.stub!(:controller).and_return(@controller)
    helper.output_buffer = "" if Rails.version < "3.0"
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

      it "should append classes" do
        html = helper.body(:append_class => "more classes") { "Body" }

        html.should have_tag("body.more")
        html.should have_tag("body.classes")
        html.should have_tag("body.en")
        html.should have_tag("body.sample-index")
      end

      it "should not have append_class attribute" do
        helper.body(:append_class => "more classes") { "Body" }.should_not have_tag("body[append_class]")
      end
    end

    it "should wrap content into main div" do
      helper.main { "Main" }.should have_tag("div#main", "Main")
    end

    it "should wrap content into page div" do
      helper.page { "Page" }.should have_tag("div#page", "Page")
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

  describe "dispatcher meta tag" do
    it "should contain meta tag" do
      @controller.class.stub!(:name).and_return("SampleController")

      html = helper.dispatcher_tag
      html.should have_tag("meta", :count => 1)
      html.should have_tag("meta[name=page][content=sample#index]")
    end

    it "should return normalized controller name for namespaced controller" do
      @controller.class.stub!(:name).and_return("Admin::SampleController")

      html = helper.dispatcher_tag
      html.should have_tag("meta[name=page][content=admin_sample#index]")
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

  describe "javascript includes" do
    before do
      @assets_dir = Pathname.new(File.dirname(__FILE__) + "/../resources/assets")
      RailsTools::Assets.stub!(:public_dir).and_return(@assets_dir)
      RailsTools::Assets.stub!(:config_file).and_return(File.dirname(__FILE__) + "/../resources/assets.yml")
    end

    it "should use defaults" do
      html = helper.javascript_includes("application")

      html.should have_tag("script[type='text/javascript']", :count => 1)
      html.should match(%r{/javascripts/application.js(\?\d+)?})
    end

    it "should return several includes for bundle when not in production" do
      RailsTools::Assets.stub!(:merge?).and_return(false)
      html = helper.javascript_includes(:base)

      html.should have_tag("script[type='text/javascript']", :count => 3)
      html.should match(%r{/javascripts/application.js(\?\d+)?})
      html.should match(%r{/javascripts/jquery.js(\?\d+)?})
      html.should match(%r{/javascripts/rails.js(\?\d+)?})
    end

    it "should return only bundle when in production" do
      RailsTools::Assets.stub!(:merge?).and_return(true)
      html = helper.javascript_includes(:base)

      html.should have_tag("script[type='text/javascript']", :count => 1)
      html.should match(%r{/javascripts/base_packaged.js(\?\d+)?})
    end
  end

  describe "stylesheet includes" do
    before do
      @assets_dir = Pathname.new(File.dirname(__FILE__) + "/../resources/assets")
      RailsTools::Assets.stub!(:public_dir).and_return(@assets_dir)
      RailsTools::Assets.stub!(:config_file).and_return(File.dirname(__FILE__) + "/../resources/assets.yml")
    end

    it "should use defaults" do
      html = helper.stylesheet_includes("application")

      html.should have_tag("link[rel='stylesheet']", :count => 1)
      html.should match(%r{/stylesheets/application.css(\?\d+)?})
    end

    it "should return several includes for bundle when not in production" do
      RailsTools::Assets.stub!(:merge?).and_return(false)
      html = helper.stylesheet_includes(:base)

      html.should have_tag("link[rel='stylesheet']", :count => 2)
      html.should match(%r{/stylesheets/reset.css(\?\d+)?})
      html.should match(%r{/stylesheets/main.css(\?\d+)?})
    end

    it "should return only bundle when in production" do
      RailsTools::Assets.stub!(:merge?).and_return(true)
      html = helper.stylesheet_includes(:base)

      html.should have_tag("link[rel='stylesheet']", :count => 1)
      html.should match(%r{/stylesheets/base_packaged.css(\?\d+)?})
    end
  end

  describe "fieldset" do
    before do
      @html = helper.fieldset("Nice legend", :class => "sample") { "<p>Fieldset</p>" }
    end

    it "should use provided options" do
      @html.should have_tag("fieldset.sample", :count => 1)
    end

    it "should use legend as text" do
      @html.should have_tag("fieldset > legend", "Nice legend")
    end

    it "should use translated legend" do
      I18n.locale = :pt
      I18n.backend.should_receive(:translations).and_return(:pt => {:sample => "Legenda"})

      @html = helper.fieldset("sample") {}
      @html.should have_tag("fieldset > legend", "Legenda")
    end

    it "should return content" do
      @html.should have_tag("fieldset > p", "Fieldset")
    end
  end
end
