module SwissKnife
  module I18nJs
    extend self
    extend Support::RemoteFile

    def file
      "javascripts/i18n.js"
    end

    def url
      "http://github.com/fnando/i18n-js/raw/master/source/i18n.js"
    end
  end
end
