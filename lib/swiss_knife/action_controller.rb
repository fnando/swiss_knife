module SwissKnife
  module ActionController
    # Page title.
    #
    #   page_title
    #   page_title "Some title"
    #   page_title :name => "Some product"
    #
    # Locale:
    #
    #   en:
    #     titles:
    #       products:
    #         show: "Product: %{name}"
    #         index: "All products"
    #
    def page_title(*args)
      if args.empty?
        page_title_get
      else
        options = args.extract_options!
        page_title_set args.first, options
      end
    end

    # Store page title options that are used on
    # I18n interpolation.
    #
    def page_title_options
      @page_title_options ||= {}
    end

    private
    def page_title_set(title, options)
      @page_title_options = options
      @page_title = title
    end

    def page_title_get
      controller = self unless respond_to?(:controller)

      controller_name = controller.class.name.underscore
      controller_name.gsub!(/\//, "_")
      controller_name.gsub!(/_controller$/, "")

      action_name = controller.action_name
      action_name = SwissKnife::Helpers::ACTION_ALIASES.fetch(action_name, action_name)

      title = @title
      title ||= t("titles.#{controller_name}.#{action_name}", page_title_options)
      title
    end
  end
end
