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

      # Retrieve the page title.
      # If no page title has been set through the method `set_page_title`, will use the
      # 'titles.controller.action' I18n scope with a default title in case this scope isn't set.
      #
      # You can set interpolation options by using the method `set_page_title`.
      #
      #   set_page_title nil, :name => user.name
      def page_title
        @page_title ||= begin
          # the controller is self when calling from controller instance
          controller = self unless respond_to?(:controller)

          controller_name = controller.controller_name
          action_name = controller.action_name

          @page_title_options ||= {}
          @page_title_options.merge!(:default => "#{controller_name.titleize} #{action_name.titleize}")
          I18n.translate("titles.#{controller_name}.#{action_name}", @page_title_options)
        end
      end

      # Set current page title
      #
      #   set_page_title "My page title"
      #   set_page_title nil, :name => user.name
      def set_page_title(title, options = {})
        @page_title = title
        @page_title_options = options
      end
    end
  end
end
