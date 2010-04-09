module RailsTools
  module ActionController
    module InstanceMethods
      def self.included(base)
        base.helper_method :page_title, :set_page_title
      end

      private

      def generate_css_from_less
        RailsTools::Less.export :from => File.join(Rails.root, "app", "stylesheets"),
                                :to   => File.join(Rails.root, "public", "stylesheets")
      end

      def generate_i18n_js
        SimplesIdeias::I18n.export!
      end

      # Retrieve the page title.
      # If no page title has been set through the method `set_page_title`, will use the
      # 'titles.controller.action' I18n scope with a default title in case this scope isn't set.
      #
      # You can set interpolation options by using the method `set_page_title`.
      #
      #   set_page_title nil, :name => user.name
      def page_title
        @page_title ||= begin
          aliases = {
            "create" => "new",
            "update" => "edit",
            "remove" => "destroy"
          }

          # the controller is self when calling from controller instance
          controller = self unless respond_to?(:controller)

          controller_name = controller.controller_name
          action_name = controller.action_name
          action_name_alias = aliases[action_name] || action_name
          options = (@page_title_options || {}).merge(:raise => true)

          # First, let's check if there's a action title without the alias
          title = I18n.translate("titles.#{controller_name}.#{action_name}", options) rescue nil

          # Then we lookup for the aliased title
          title ||= I18n.translate("titles.#{controller_name}.#{action_name_alias}", options) rescue nil

          # Finally we set it as titleized
          title ||= "#{controller_name.titleize} #{action_name.titleize}"

          title
        end
      end

      # Set current page title
      #
      #   set_page_title "My page title"
      #   set_page_title nil, :name => user.name
      def set_page_title(*args)
        options = args.extract_options!
        @page_title = args.first
        @page_title_options = options
      end
    end
  end
end
