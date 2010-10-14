require "spec_helper"

describe SwissKnife::Helpers do
  before do
    I18n.locale = :en
    @controller = helper.send(:controller)
    @controller.stub(:controller_name => "sample", :action_name => "index")
    helper.stub(:controller => @controller)
  end

  describe "#flash_messages" do
    before do
      flash[:notice] = "Notice"
      flash[:warning] = "Warning"
      flash[:error] = "Error"
    end

    subject { helper.flash_messages }

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
        @controller.stub(:action_name => "create")
        helper.body { "Body" }.should have_tag("body.sample-new")

        @controller.stub(:action_name => "update")
        helper.body { "Body" }.should have_tag("body.sample-edit")

        @controller.stub(:action_name => "destroy")
        helper.body { "Body" }.should have_tag("body.sample-destroy")
      end

      it "should use custom settings" do
        html = helper.body(:id => "page", :class => "dark", :onload => "init();") { "Body" }

        html.should have_tag("body#page")
        html.should have_tag("body.dark")
        html.should have_tag("body[onload='init();']")
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

    it "should wrap content into sidebar" do
      helper.sidebar { "Sidebar" }.should have_tag("sidebar", "Sidebar")
    end

    it "should wrap content into footer" do
      helper.footer { "Footer" }.should have_tag("footer", "Footer")
    end

    it "should wrap content into header" do
      helper.header { "Header" }.should have_tag("header", "Header")
    end

    it "should wrap content into article" do
      helper.article { "Article" }.should have_tag("article", "Article")
    end

    it "should wrap content into section" do
      helper.section { "Section" }.should have_tag("section", "Section")
    end

    it "should use other options like css class" do
      html = helper.wrapper(:div, :id => "container", :class => "rounded") { "Some content" }
      html.should have_tag("div#container.rounded", "Some content")
    end
  end

  describe "#dispatcher_tag" do
    it "should contain meta tag" do
      @controller.class.stub!(:name).and_return("SampleController")

      html = helper.dispatcher_tag
      html.should have_tag("meta")
      html.should have_tag("meta[name=page][content='sample#index']")
    end

    it "should return normalized controller name for namespaced controller" do
      @controller.class.stub(:name => "Admin::SampleController")
      helper.dispatcher_tag.should have_tag("meta[name=page][content='admin_sample#index']", :count => 1)
    end
  end

  describe "#mail_to" do
    subject { helper.mail_to("john@doe.com") }

    it "should be encrypted" do
      subject.should_not match(/john@doe\.com/)
    end

    it "should not have plain-text protocol" do
      subject.should_not match(/mailto:/)
    end

    it "should use provided label" do
      helper.mail_to("john@doe.com", "john's email").should have_tag("a", "john's email")
    end
  end

  context "assets" do
    before do
      @assets_dir = Pathname.new(File.dirname(__FILE__) + "/../resources/assets")
      SwissKnife::Assets.stub(:public_dir => @assets_dir)
      SwissKnife::Assets.stub(:config_file => File.dirname(__FILE__) + "/../resources/assets.yml")
    end

    describe "javascript includes" do
      it "should use defaults" do
        html = helper.javascript_includes("application")

        html.should have_tag("script[type='text/javascript']", :count => 1)
        html.should match(%r{/javascripts/application.js(\?\d+)?})
      end

      it "should return several includes for bundle when not in production" do
        SwissKnife::Assets.stub(:merge? => false)
        html = helper.javascript_includes(:base)

        html.should have_tag("script[type='text/javascript']", :count => 3)
        html.should match(%r{/javascripts/application.js(\?\d+)?})
        html.should match(%r{/javascripts/jquery.js(\?\d+)?})
        html.should match(%r{/javascripts/rails.js(\?\d+)?})
      end

      it "should return bundle only when in production" do
        SwissKnife::Assets.stub(:merge? => true)
        html = helper.javascript_includes(:base)

        html.should have_tag("script[type='text/javascript']", :count => 1)
        html.should match(%r{/javascripts/base_packaged.js(\?\d+)?})
      end
    end

    describe "stylesheet includes" do
      it "should use defaults" do
        html = helper.stylesheet_includes("application")

        html.should have_tag("link[rel='stylesheet']", :count => 1)
        html.should match(%r{/stylesheets/application.css(\?\d+)?})
      end

      it "should return several includes for bundle when not in production" do
        SwissKnife::Assets.stub(:merge? => false)
        html = helper.stylesheet_includes(:base)

        html.should have_tag("link[rel='stylesheet']", :count => 2)
        html.should match(%r{/stylesheets/reset.css(\?\d+)?})
        html.should match(%r{/stylesheets/main.css(\?\d+)?})
      end

      it "should return only bundle when in production" do
        SwissKnife::Assets.stub(:merge? => true)
        html = helper.stylesheet_includes(:base)

        html.should have_tag("link[rel='stylesheet']", :count => 1)
        html.should match(%r{/stylesheets/base_packaged.css(\?\d+)?})
      end
    end
  end

  describe "#fieldset" do
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

  describe "#gravatar_tag" do
    before do
      ActionController::Base.asset_host = "http://example.com"
      @email = "john@doe.com"
    end

    it "should return an image" do
      helper.gravatar_tag(@email).should have_tag("img.gravatar", :count => 1)
    end

    it "should use default options" do
      uri = uri_for(helper.gravatar_tag(@email))
      uri.scheme.should == "http"
      uri.host.should == "www.gravatar.com"
      uri.path.should == "/avatar/#{Digest::MD5.hexdigest(@email)}.jpg"
      uri.params.should == {"s" => "32", "r" => "g", "d" => "http://example.com/images/gravatar.jpg"}
    end

    it "should use gravatar hash" do
      uri = uri_for(helper.gravatar_tag("098f6bcd4621d373cade4e832627b4f6"))
      uri.path.should == "/avatar/098f6bcd4621d373cade4e832627b4f6.jpg"
    end

    it "should use custom default image" do
      uri = uri_for(helper.gravatar_tag(@email, :default => "custom.jpg"))
      uri.params["d"].should == "http://example.com/images/custom.jpg"
    end

    it "should use custom default image" do
      uri = uri_for(helper.gravatar_tag(@email, :default => "custom.jpg"))
      uri.params["d"].should == "http://example.com/images/custom.jpg"
    end

    it "should use predefined default image" do
      uri = uri_for(helper.gravatar_tag(@email, :default => :mm))
      uri.params["d"].should == "mm"
    end

    it "should use custom size" do
      uri = uri_for(helper.gravatar_tag(@email, :size => 80))
      uri.params["s"].should == "80"
    end

    it "should use custom rating" do
      uri = uri_for(helper.gravatar_tag(@email, :rating => "pg"))
      uri.params["r"].should == "pg"
    end

    it "should use secure host when in a secure request" do
      helper.request.should_receive(:ssl?).and_return(true)
      uri = uri_for(helper.gravatar_tag(@email))
      uri.host.should == "secure.gravatar.com"
      uri.scheme.should == "https"
    end

    it "should use secure host when using :ssl option" do
      uri = uri_for(helper.gravatar_tag(@email, :ssl => true))
      uri.host.should == "secure.gravatar.com"
      uri.scheme.should == "https"
    end

    it "should use alt" do
      helper.gravatar_tag(@email, :alt => "alt text").should match(/\balt="alt text"/)
    end

    it "should use title" do
      helper.gravatar_tag(@email, :title => "title text").should match(/\btitle="title text"/)
    end

    private
    def uri_for(html)
      html = Nokogiri(html)
      uri = URI.parse(html.css("img.gravatar").first["src"])

      OpenStruct.new({
        :scheme => uri.scheme,
        :params => CGI.parse(uri.query).inject({}) {|buffer, (name, value)| buffer.merge(name => value.first)},
        :host   => uri.host,
        :path   => uri.path
      })
    end
  end

  describe "#submit_or_cancel" do
    it "should use defaults" do
      html = helper.submit_or_cancel("/some/path")
      html.should have_tag("a.cancel[href='/some/path']", :text => "Cancel")
      html.should have_tag("input.button[type=submit][value=Submit]")
    end

    it "should use custom link text from I18n file" do
      I18n.backend.stub :translations => {:en => {:go_back => "Go back"}}
      html = helper.submit_or_cancel("/some/path", :cancel => :go_back)
      html.should have_tag("a.cancel", :text => "Go back")
    end

    it "should use custom link text" do
      html = helper.submit_or_cancel("/some/path", :cancel => "Go back")
      html.should have_tag("a.cancel", :text => "Go back")
    end

    it "should use custom button text from I18n file" do
      I18n.backend.stub :translations => {:en => {:send => "Send"}}
      html = helper.submit_or_cancel("/some/path", :button => :send)
      html.should have_tag("input[type=submit][value=Send]")
    end

    it "should use custom button text" do
      html = helper.submit_or_cancel("/some/path", :button => "Send")
      html.should have_tag("input[type=submit][value=Send]")
    end
  end
end
