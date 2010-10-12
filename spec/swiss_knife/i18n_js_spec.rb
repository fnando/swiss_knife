require "spec_helper"

describe SwissKnife::I18nJs do
  let(:url)  { "http://github.com/fnando/i18n-js/raw/master/source/i18n.js" }
  let(:file) { "javascripts/i18n.js" }

  it_behaves_like "remote file"
end
