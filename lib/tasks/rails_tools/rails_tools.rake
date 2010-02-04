desc "Generate CSS from Less files"
task "less:generate" do
  require "config/environment"
  require "rails_tools/less"
  RailsTools::Less.export :from => File.join(Rails.root, "app", "stylesheets"),
                          :to   => File.join(Rails.root, "public", "stylesheets")
end
