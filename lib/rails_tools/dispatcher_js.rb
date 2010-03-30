module RailsTools
  module DispatcherJs
    extend self

    def update(options = {})
      File.open(File.join(options[:to], "dispatcher.js"), "w+") do |f|
        f << open("http://github.com/fnando/dispatcher-js/raw/master/dispatcher.js").read
      end
    end
  end
end
