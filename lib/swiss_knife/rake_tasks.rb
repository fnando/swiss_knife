namespace :swiss_knife do
  namespace :javascripts do
    desc "Update all JavaScripts"
    task :update => %w[ i18njs jquery jquery_ujs modernizr dispatcher ]

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

    desc "Update Modernizr"
    task :modernizr => :environment do
      SwissKnife::Modernizr.update
    end

    desc "Update Dispatcher JS"
    task :dispatcher => :environment do
      SwissKnife::DispatcherJs.update
    end
  end
end