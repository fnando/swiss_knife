module SwissKnife
  module JqueryUjs
    extend self
    extend Support::RemoteFile

    def file
      "javascripts/rails.js"
    end

    def url
      "https://raw.github.com/rails/jquery-ujs/master/src/rails.js"
    end
  end
end
