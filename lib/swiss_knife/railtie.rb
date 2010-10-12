require "rails/railtie"

module SwissKnife
  class Railtie < Rails::Railtie
    generators do
      # require "swiss_knife/generators"
    end

    rake_tasks do
      require "swiss_knife/rake_tasks"
    end

    config.after_initialize do
      ActiveSupport.on_load(:action_controller) do
        include SwissKnife::ActionController
        helper SwissKnife::Helpers
        helper_method :page_title
      end
    end
  end
end
