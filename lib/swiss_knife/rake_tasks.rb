namespace :swiss_knife do
  namespace :assets do
    desc "Pack everything (images, CSS & JavaScript)"
    task :all => %w[swiss_knife:assets:js swiss_knife:assets:css]

    desc "Pack images"
    task :images do
      SwissKnife::SmusherIt.convert_directory Rails.root.join("public/images")
    end

    desc "Pack CSS"
    task :css do
      SwissKnife::Assets.export(:stylesheets)
    end

    desc "Pack JavaScript"
    task :js do
      SwissKnife::Assets.export(:javascripts)
    end
  end

  namespace :javascripts do
    desc "Update all JavaScripts"
    task :update => %w[ i18njs jquery jquery_ujs dispatcher ]

    desc "Update I18n JS"
    task :i18njs => :environment do
      SwissKnife::I18nJs.update
    end

    desc "Update jQuery"
    task :jquery => :environment do
      SwissKnife::Jquery.update
    end

    desc "Update jQuery UJS"
    task :jquery_ujs => :environment do
      SwissKnife::JqueryUjs.update
    end

    desc "Update Dispatcher JS"
    task :dispatcher => :environment do
      SwissKnife::DispatcherJs.update
    end
  end
end
