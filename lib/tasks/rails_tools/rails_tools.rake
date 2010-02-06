desc "Generate CSS from Less files"
task "less:generate" => :require_env do
  require "rails_tools/less"
  RailsTools::Less.export :from => File.join(Rails.root, "app", "stylesheets"),
                          :to   => File.join(Rails.root, "public", "stylesheets")
end

desc "Update jQuery Javascript library"
task "jquery:update" => :require_env do
  require "rails_tools/jquery"
  require "open-uri"
  RailsTools::Jquery.update :to => File.join(Rails.root, "public", "javascripts")
end

desc "Update Rails JS Javascript library"
task "rails_js:update" => :require_env do
  require "rails_tools/rails_js"
  require "open-uri"
  RailsTools::RailsJs.update :to => File.join(Rails.root, "public", "javascripts")
end

task :require_env do
  begin
    require "config/environment"
  rescue Exception => e
    require "config/application"
  end
end
