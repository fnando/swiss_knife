module SwissKnife
  module DispatcherJs
    extend self
    extend Support::RemoteFile

    def file
      "javascripts/dispatcher.js"
    end

    def url
      "https://raw.github.com/fnando/dispatcher-js/master/dispatcher.js"
    end
  end
end
