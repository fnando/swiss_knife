module RailsTools
  class Assets
    class << self
      attr_accessor :configuration
    end

    EXTENSIONS = { :javascripts => "js", :stylesheets => "css" }

    def self.config_file
      Rails.root.join("config", "assets.yml")
    end

    def self.config
      YAML.load_file(config_file)
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

    def self.export(type)
      assets_dir = public_dir.join(type.to_s)
      ext = EXTENSIONS[type]
      group = config[type.to_s]

      return unless group

      group.each do |name, files|
        File.open(assets_dir.join("#{name}_packaged.#{ext}"), "w+") do |f|
          files.each do |file|
            file << ".#{ext}" unless file =~ /\.#{ext}$/i

            f << File.read(assets_dir.join(file))
            f << "\n\n"
          end
        end
      end
    end
  end
end
