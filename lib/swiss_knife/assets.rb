module SwissKnife
  class Assets
    class << self
      attr_accessor :configuration
    end

    EXTENSIONS = { :javascripts => "js", :stylesheets => "css" }

    def self.config_file
      Rails.root.join("config/assets.yml")
    end

    def self.config
      @config ||= YAML.load_file(config_file)
    end

    def self.public_dir
      Rails.root.join("public")
    end

    def self.config?
      File.file?(config_file) && config
    end

    def self.merge?
      config? && Rails.env.production?
    end

    # Taken from http://github.com/sbecker/asset_packager/
    def self.compress_js(source)
      jsmin_path = File.dirname(__FILE__)
      tmp_path = Rails.root.join("tmp/js")

      # write out to a temp file
      File.open("#{tmp_path}_uncompressed.js", "w") {|f| f.write(source) }

      # compress file with JSMin library
      `ruby #{jsmin_path}/jsmin.rb <#{tmp_path}_uncompressed.js >#{tmp_path}_compressed.js \n`

      # read it back in and trim it
      result = ""
      File.open("#{tmp_path}_compressed.js", "r") { |f| result += f.read.strip }

      # delete temp files if they exist
      File.delete("#{tmp_path}_uncompressed.js") if File.exists?("#{tmp_path}_uncompressed.js")
      File.delete("#{tmp_path}_compressed.js") if File.exists?("#{tmp_path}_compressed.js")

      result
    end

    def self.compress_css(source)
      source
    end

    def self.export(type)
      assets_dir = public_dir.join(type.to_s)
      ext = EXTENSIONS[type]
      group = config[type.to_s]

      return unless group

      group.each do |name, files|
        File.open(assets_dir.join("#{name}_packaged.#{ext}"), "w+") do |f|
          files.each do |file|
            file << ".#{ext}" unless file =~ /\.#{ext}$/i

            f << send("compress_#{ext}", File.read(assets_dir.join(file)))
            f << "\n;"
          end
        end
      end
    end
  end
end
