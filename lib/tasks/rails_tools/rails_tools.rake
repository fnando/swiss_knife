desc "Generate CSS from Less files"
task "less:generate" => :environment do
  require "rails_tools/less"
  RailsTools::Less.export :from => File.join(Rails.root, "app", "stylesheets"),
                          :to   => File.join(Rails.root, "public", "stylesheets")
end

desc "Update jQuery Javascript library"
task "jquery:update" => :environment do
  require "rails_tools/jquery"
  require "open-uri"
  RailsTools::Jquery.update :to => File.join(Rails.root, "public", "javascripts")
end

desc "Update Rails JS Javascript library"
task "rails_js:update" => :environment do
  require "rails_tools/rails_js"
  require "open-uri"
  RailsTools::RailsJs.update :to => File.join(Rails.root, "public", "javascripts")
end

desc "Update I18n JS Javascript library"
task "i18n_js:update" => :environment do
  require "rails_tools/i18n_js"
  require "open-uri"
  RailsTools::I18nJs.update :to => File.join(Rails.root, "public", "javascripts")
end
