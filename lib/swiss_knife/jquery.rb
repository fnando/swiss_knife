module SwissKnife
  module Jquery
    extend self
    extend Support::RemoteFile

    def file
      "javascripts/jquery.js"
    end

    def url
      "http://code.jquery.com/jquery-latest.min.js"
    end
  end
end
