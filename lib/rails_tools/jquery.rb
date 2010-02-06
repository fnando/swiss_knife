module RailsTools
  module Jquery
    extend self

    def update(options = {})
      File.open(File.join(options[:to], "jquery-latest.min.js"), "w+") do |f|
        f << open("http://code.jquery.com/jquery-latest.min.js").read
      end
    end
  end
end
