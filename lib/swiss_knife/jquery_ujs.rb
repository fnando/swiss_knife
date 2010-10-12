module SwissKnife
  module JqueryUjs
    extend self
    extend Support::RemoteFile

    def file
      "javascripts/rails.js"
    end

    def url
      "http://github.com/rails/jquery-ujs/raw/master/src/rails.js"
    end
  end
end
