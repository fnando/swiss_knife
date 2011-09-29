module SwissKnife
  module I18nJs
    extend self
    extend Support::RemoteFile

    def file
      "javascripts/i18n.js"
    end

    def url
      "https://raw.github.com/fnando/i18n-js/master/vendor/assets/javascripts/i18n.js"
    end
  end
end
