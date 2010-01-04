require "rails_tools/helper"
require "rails_tools/action_controller"

module RailsTool
end

ActionController::Base.send :include, RailsTools::ActionController::InstanceMethods
