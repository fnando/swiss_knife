require "rails/railtie"

module SwissKnife
  class Railtie < Rails::Railtie
    initializer "swiss_knife.initialize" do
      ::ActionController::Base.instance_eval do
        helper SwissKnife::Helpers
      end

      ::I18n.load_path += Dir[File.dirname(__FILE__) + "/../../locales/*.yml"]
    end
  end
end
