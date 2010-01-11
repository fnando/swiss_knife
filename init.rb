require "rails_tools"

config.to_prepare do
  ApplicationController.helper(RailsToolsHelper)
end
