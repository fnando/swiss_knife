module RailsTools
  module RailsJs
    extend self

    def update(options = {})
      File.open(File.join(options[:to], "rails.min.js"), "w+") do |f|
        f << open("http://github.com/fnando/rails-js/raw/master/rails.min.js").read
      end
    end
  end
end
