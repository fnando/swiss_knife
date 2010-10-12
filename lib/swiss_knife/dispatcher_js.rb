module SwissKnife
  module DispatcherJs
    extend self
    extend Support::RemoteFile

    def file
      "javascripts/dispatcher.js"
    end

    def url
      "http://github.com/fnando/dispatcher-js/raw/master/dispatcher.js"
    end
  end
end
