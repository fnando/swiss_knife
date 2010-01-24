require "rails_tools"

config.to_prepare do
  ApplicationController.helper RailsToolsHelper
  ApplicationController.before_filter :generate_css_from_less if Rails.env.development? && defined?(::Less)
end
