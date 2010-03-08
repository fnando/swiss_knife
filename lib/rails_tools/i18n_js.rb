module RailsTools
  module I18nJs
    extend self

    def update(options = {})
      File.open(File.join(options[:to], "i18n.js"), "w+") do |f|
        f << open("http://github.com/fnando/i18n-js/raw/master/lib/i18n.js").read
      end
    end
  end
end
