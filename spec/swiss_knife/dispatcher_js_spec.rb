require "spec_helper"

describe SwissKnife::DispatcherJs do
  let(:url)  { "http://github.com/fnando/dispatcher-js/raw/master/dispatcher.js" }
  let(:file) { "javascripts/dispatcher.js" }

  it_behaves_like "remote file"
end
