require "spec_helper"

describe RailsTools::Assets do
  before do
    @assets_dir = Pathname.new(File.dirname(__FILE__) + "/../resources/assets")
    @config = YAML.load_file(File.dirname(__FILE__) + "/../resources/assets.yml")
    YAML.stub!(:load_file).and_return(@config)
  end

  it "should load config file" do
    pending
    YAML.should_receive(:load_file).once.and_return(@config)
    2.times { RailsTools::Assets.config }
  end

  it "should return public dir" do
    RailsTools::Assets.public_dir.should == ::Rails.root.join("public")
  end

  context "export" do
    before do
      Dir["#{@assets_dir}/**/*_packaged.*"].each {|f| FileUtils.rm(f) rescue nil}
      RailsTools::Assets.stub!(:public_dir).and_return(@assets_dir)
    end

    it "should generate javascript bundles" do
      RailsTools::Assets.export(:javascripts)

      File.should be_file(@assets_dir.join("javascripts", "base_packaged.js"))
      File.should be_file(@assets_dir.join("javascripts", "libs_packaged.js"))
    end

    it "should ignore missing javascript section" do
      YAML.stub!(:load_file).and_return({})

      lambda { RailsTools::Assets.export(:javascripts) }.should_not raise_error
    end

    it "should ignore missing stylesheet section" do
      YAML.stub!(:load_file).and_return({})

      lambda { RailsTools::Assets.export(:stylesheets) }.should_not raise_error
    end

    it "should merge javascript files in the right order" do
      RailsTools::Assets::export(:javascripts)
      source = File.read(@assets_dir.join("javascripts", "base_packaged.js"))
      matches = source.scan(/name: (.*?)$/).to_a.flatten

      assert_equal "jquery", matches[0]
      assert_equal "rails", matches[1]
      assert_equal "application", matches[2]
      assert_nil matches[3]
    end

    it "should merge stylesheet files in the right order" do
      RailsTools::Assets::export(:stylesheets)
      source = File.read(@assets_dir.join("stylesheets", "base_packaged.css"))
      matches = source.scan(/name: (.*?)$/).to_a.flatten

      assert_equal "reset", matches[0]
      assert_equal "main", matches[1]
      assert_nil matches[2]
    end

    it "should generate stylesheet bundles" do
      RailsTools::Assets.export(:stylesheets)

      File.should be_file(@assets_dir.join("stylesheets", "base_packaged.css"))
      File.should be_file(@assets_dir.join("stylesheets", "shared_packaged.css"))
    end
  end
end
