require "spec_helper"

describe SwissKnife::JqueryUjs do
  let(:url)  { "http://github.com/rails/jquery-ujs/raw/master/src/rails.js" }
  let(:file) { "javascripts/rails.js" }

  it_behaves_like "remote file"
end
