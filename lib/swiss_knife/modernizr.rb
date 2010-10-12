module SwissKnife
  module Modernizr
    extend self
    extend Support::RemoteFile

    def file
      "javascripts/modernizr.js"
    end

    def url
      "http://github.com/Modernizr/Modernizr/raw/master/modernizr.js"
    end
  end
end
