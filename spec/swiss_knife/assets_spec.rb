require "spec_helper"

describe SwissKnife::Assets do
  let!(:public_dir) { Pathname(File.dirname(__FILE__) + "/../resources/assets") }
  let!(:config) { YAML.load_file(File.dirname(__FILE__) + "/../resources/assets.yml") }

  before do
    YAML.stub :load_file => config
  end

  it "should load config file" do
    YAML.should_receive(:load_file).once.and_return(config)
    SwissKnife::Assets.instance_variable_set "@config", nil
    2.times { SwissKnife::Assets.config }
  end

  it "should return public dir" do
    SwissKnife::Assets.public_dir.should == ::Rails.root.join("public")
  end

  context "export" do
    before do
      SwissKnife::Assets.stub :public_dir => public_dir
    end

    it "should generate javascript bundles" do
      SwissKnife::Assets.export(:javascripts)

      File.should be_file(public_dir.join("javascripts", "base_packaged.js"))
      File.should be_file(public_dir.join("javascripts", "libs_packaged.js"))
    end

    it "should ignore missing javascript section" do
      YAML.stub :load_file => {}

      expect { SwissKnife::Assets.export(:javascripts) }.to_not raise_error
    end

    it "should ignore missing stylesheet section" do
      YAML.stub :load_file => {}

      expect { SwissKnife::Assets.export(:stylesheets) }.to_not raise_error
    end

    it "should merge javascript files in the right order" do
      SwissKnife::Assets::export(:javascripts)
      source = File.read(public_dir.join("javascripts", "base_packaged.js"))
      matches = source.scan(/name = "(.*?)"/x).to_a.flatten

      matches[0].should == "jquery"
      matches[1].should == "rails"
      matches[2].should == "application"
      matches[3].should be_nil
    end

    it "should merge stylesheet files in the right order" do
      SwissKnife::Assets::export(:stylesheets)
      source = File.read(public_dir.join("stylesheets", "base_packaged.css"))
      matches = source.scan(/name: (.*?)$/).to_a.flatten

      matches[0].should == "reset"
      matches[1].should == "main"
      matches[2].should be_nil
    end

    it "should generate stylesheet bundles" do
      SwissKnife::Assets.export(:stylesheets)

      File.should be_file(public_dir.join("stylesheets", "base_packaged.css"))
      File.should be_file(public_dir.join("stylesheets", "shared_packaged.css"))
    end
  end
end
