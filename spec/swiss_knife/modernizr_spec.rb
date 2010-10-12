require "spec_helper"

describe SwissKnife::Modernizr do
  let(:url)  { "http://github.com/Modernizr/Modernizr/raw/master/modernizr.js" }
  let(:file) { "javascripts/modernizr.js" }

  it_behaves_like "remote file"
end
