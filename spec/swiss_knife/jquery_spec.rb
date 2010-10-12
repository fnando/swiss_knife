require "spec_helper"

describe SwissKnife::Jquery do
  let(:url)  { "http://code.jquery.com/jquery-latest.min.js" }
  let(:file) { "javascripts/jquery.js" }

  it_behaves_like "remote file"
end
