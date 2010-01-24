module RailsTools
  module Less
    extend self

    def export(options = {})
      source = options.delete(:from)
      destiny = options.delete(:to)
      files = Dir["#{source}/**/*.{less,css}"]

      files.each do |file|
        filename = File.basename(file)

        # Skip partial files like +_name.less+.
        next if filename =~ /^_/

        # Retrieve the relative path to the asset
        relative_path = file.split(source).last.to_s.gsub(/^\//, "")

        # Set full destiny path
        full_path = File.join(destiny, relative_path)

        # Create directories where generated files will reside
        FileUtils.mkdir_p File.dirname(full_path)

        # FileUtils.cd source

        if filename =~ /\.css$/i
          # Copy CSS files to stylesheets directory.
          FileUtils.cp file, full_path
        else
          # Generate CSS from .less files
          stylesheet = ::Less.parse File.open(file)
          full_path.gsub!(/.less$/i, ".css")
          File.open(full_path, "w+") {|f| f << stylesheet }
        end
      end
    end
  end
end
