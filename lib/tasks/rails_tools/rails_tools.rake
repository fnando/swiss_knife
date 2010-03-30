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

desc "Update Dispatcher JS Javascript library"
task "dispatcher_js:update" => :environment do
  require "rails_tools/dispatcher_js"
  require "open-uri"
  RailsTools::DispatcherJs.update :to => File.join(Rails.root, "public", "javascripts")
end

desc "Update I18n JS Javascript library"
task "i18n:update" => :environment do
  require "rails_tools/i18n_js"
  require "open-uri"
  RailsTools::I18nJs.update :to => File.join(Rails.root, "public", "javascripts")
end

desc "Merge assets (JavaScript & CSS) into one single file"
task "assets:merge" => :environment do
  require "rails_tools/assets"

  config_file = Rails.root.join("config", "assets.yml")

  if File.file?(config_file)
    RailsTools::Assets.export(:javascripts)
    RailsTools::Assets.export(:stylesheets)
  else
    puts "We need a config/assets.yml file. As we didn't find any, we created a sample one."
    puts "Please tweak it before continuing."
    File.open(config_file, "w+") do |f|
      sample = <<-TXT
javascripts:
  base:
    - rails.js
    - application.js
stylesheets:
  base:
    - reset.css
    - general.css
      TXT
    end

    f << sample
    exit 1
  end
end
