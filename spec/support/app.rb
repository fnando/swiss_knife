require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require

class App < Rails::Application
  config.eager_load = false
  config.secret_token = SecureRandom.hex(100)
  config.secret_key_base = SecureRandom.hex(100)
end

App.initialize!
