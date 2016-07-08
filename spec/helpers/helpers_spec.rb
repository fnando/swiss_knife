require "spec_helper"

describe SwissKnife::Helpers do
  before do
    I18n.locale = :en
    @controller = helper.send(:controller)
    allow(@controller).to receive_messages(:controller_name => "sample", :action_name => "index")
    allow(helper).to receive_messages(:controller => @controller)
  end

  describe "#flash_messages" do
    before do
      flash[:notice] = "Notice"
      flash[:warning] = "Warning"
      flash[:error] = "Error"
    end

    subject { helper.flash_messages }

    it { is_expected.to be_html_safe }

    it "should render multiple flash messages" do
      expect(subject).to have_tag("p.message", :count => 3)
    end

    it "should render error message" do
      expect(subject).to have_tag("p.error", "Error")
    end

    it "should render warning message" do
      expect(subject).to have_tag("p.warning", "Warning")
    end

    it "should render notice message" do
      expect(subject).to have_tag("p.notice", "Notice")
    end
  end

  describe "block wrappers" do
    context "body" do
      subject { helper.body { "Body" } }

      it { is_expected.to be_html_safe }

      it "should use defaults" do
        expect(subject).to have_tag("body", :count => 1)
        expect(subject).to have_tag("body#sample-page")
        expect(subject).to have_tag("body.sample-index")
        expect(subject).to have_tag("body.en")
        expect(subject).to have_tag("body.test")
      end

      it "should use alias for create action" do
        allow(@controller).to receive_messages(:action_name => "create")
        html = helper.body { "Body" }

        expect(html).to have_tag("body.sample-new")
        expect(html).to have_tag("body.sample-create")
      end

      it "should use alias for update action" do
        allow(@controller).to receive_messages(:action_name => "update")
        expect(helper.body { "Body" }).to have_tag("body.sample-edit")
      end

      it "should use alias for delete action" do
        allow(@controller).to receive_messages(:action_name => "destroy")
        expect(helper.body { "Body" }).to have_tag("body.sample-destroy")
      end

      it "should use custom settings" do
        subject = helper.body(:id => "page", :class => "dark", :onload => "init();") { "Body" }

        expect(subject).to have_tag("body#page")
        expect(subject).to have_tag("body.dark")
        expect(subject).to have_tag("body[onload='init();']")
      end

      it "should append classes" do
        subject = helper.body(:append_class => "more classes") { "Body" }

        expect(subject).to have_tag("body.more")
        expect(subject).to have_tag("body.classes")
        expect(subject).to have_tag("body.en")
        expect(subject).to have_tag("body.sample-index")
      end

      it "should not have append_class attribute" do
        expect(helper.body(:append_class => "more classes") { "Body" }).not_to have_tag("body[append_class]")
      end
    end

    it "should wrap content into main div" do
      expect(helper.main { "Main" }).to have_tag("div#main", "Main")
    end

    it "should wrap content into page div" do
      expect(helper.page { "Page" }).to have_tag("div#page", "Page")
    end

    it "should wrap content into sidebar" do
      expect(helper.sidebar { "Sidebar" }).to have_tag("sidebar", "Sidebar")
    end

    it "should wrap content into footer" do
      expect(helper.footer { "Footer" }).to have_tag("footer", "Footer")
    end

    it "should wrap content into header" do
      expect(helper.header { "Header" }).to have_tag("header", "Header")
    end

    it "should wrap content into article" do
      expect(helper.article { "Article" }).to have_tag("article", "Article")
    end

    it "should wrap content into section" do
      expect(helper.section { "Section" }).to have_tag("section", "Section")
    end

    it "should use other options like css class" do
      subject = helper.wrapper(:div, :id => "container", :class => "rounded") { "Some content" }
      expect(subject).to have_tag("div#container.rounded", "Some content")
    end
  end

  describe "#fieldset" do
    subject { helper.fieldset("Nice legend", :class => "sample") { "<p>Fieldset</p>" } }

    it { is_expected.to be_html_safe }

    it "should use provided options" do
      expect(subject).to have_tag("fieldset.sample", :count => 1)
    end

    it "should use legend as text" do
      expect(subject).to have_tag("fieldset > legend", "Nice legend")
    end

    it "should use translated legend" do
      I18n.locale = "pt-BR"
      expect(I18n.backend).to receive(:translations).and_return(:"pt-BR" => {sample: "Legenda"})

      subject = helper.fieldset("sample") {}
      expect(subject).to have_tag("fieldset > legend", "Legenda")
    end

    it "should return content" do
      expect(subject).to have_tag("fieldset > p", "Fieldset")
    end
  end

  describe "#gravatar_tag" do
    before do
      ActionController::Base.asset_host = "http://example.com"
    end

    let(:email) { "john@doe.com" }
    subject { helper.gravatar_tag(email) }

    it "should return an image" do
      expect(subject).to have_tag("img.gravatar", :count => 1)
    end

    it "should use gravatar hash" do
      uri = uri_for(helper.gravatar_tag("098f6bcd4621d373cade4e832627b4f6"))
      expect(uri.path).to eq("/avatar/098f6bcd4621d373cade4e832627b4f6.jpg")
    end

    it "should use custom default image" do
      uri = uri_for(helper.gravatar_tag(email, :default => "images/custom.jpg"))
      expect(uri.params["d"]).to eq("http://example.com/images/custom.jpg")
    end

    it "should use custom default image" do
      uri = uri_for(helper.gravatar_tag(email, :default => "images/custom.jpg"))
      expect(uri.params["d"]).to eq("http://example.com/images/custom.jpg")
    end

    it "should use predefined default image" do
      uri = uri_for(helper.gravatar_tag(email, :default => :mm))
      expect(uri.params["d"]).to eq("mm")
    end

    it "should use custom size" do
      uri = uri_for(helper.gravatar_tag(email, :size => 80))
      expect(uri.params["s"]).to eq("80")
    end

    it "should use custom rating" do
      uri = uri_for(helper.gravatar_tag(email, :rating => "pg"))
      expect(uri.params["r"]).to eq("pg")
    end

    it "should always use secure host" do
      uri = uri_for(helper.gravatar_tag(email))
      expect(uri.host).to eq("secure.gravatar.com")
      expect(uri.scheme).to eq("https")
    end

    it "should use alt" do
      expect(helper.gravatar_tag(email, :alt => "alt text")).to match(/\balt="alt text"/)
    end

    it "should use title" do
      expect(helper.gravatar_tag(email, :title => "title text")).to match(/\btitle="title text"/)
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
      subject = helper.submit_or_cancel("/some/path")
      expect(subject).to have_tag("a.cancel[href='/some/path']", :text => "Cancel")
      expect(subject).to have_tag("input.button[type=submit][value=Submit]")
    end

    it "should use custom link text from I18n file" do
      allow(I18n.backend).to receive_messages :translations => {:en => {:go_back => "Go back"}}
      subject = helper.submit_or_cancel("/some/path", :cancel => :go_back)
      expect(subject).to have_tag("a.cancel", :text => "Go back")
    end

    it "should use custom link text" do
      subject = helper.submit_or_cancel("/some/path", :cancel => "Go back")
      expect(subject).to have_tag("a.cancel", :text => "Go back")
    end

    it "should use custom button text from I18n file" do
      allow(I18n.backend).to receive_messages :translations => {:en => {:send => "Send"}}
      subject = helper.submit_or_cancel("/some/path", :button => :send)
      expect(subject).to have_tag("input[type=submit][value=Send]")
    end

    it "should use custom button text" do
      subject = helper.submit_or_cancel("/some/path", :button => "Send")
      expect(subject).to have_tag("input[type=submit][value=Send]")
    end
  end
end
