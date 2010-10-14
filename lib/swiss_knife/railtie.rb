require "rails/railtie"

module SwissKnife
  class Railtie < Rails::Railtie
    generators do
      # require "swiss_knife/generators"
    end

    rake_tasks do
      require "swiss_knife/rake_tasks"
    end

    initializer "swiss_knife.initialize" do
      ::ActionController::Base.instance_eval do
        include SwissKnife::ActionController
        helper SwissKnife::Helpers
        helper_method :page_title
      end

      ::I18n.load_path += Dir[File.dirname(__FILE__) + "/../../locales/*.yml"]
    end
  end
end
