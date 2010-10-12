require "rails/railtie"

module SwissKnife
  class Railtie < Rails::Railtie
    generators do
      # require "swiss_knife/generators"
    end

    rake_tasks do
      require "swiss_knife/rake_tasks"
    end

    initializer "swiss_knife.initialize" do |app|
      ApplicationController.send :include, SwissKnife::ActionController
      ApplicationController.helper SwissKnife::Helpers
      ApplicationController.helper_method :page_title
    end
  end
end
