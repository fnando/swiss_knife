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

    private
    def page_title_set(title, options)
      @_page_title_options = {:title => title, :options => options}
    end

    def page_title_get
      controller = self unless respond_to?(:controller)
      controller_name = controller.controller_name
      action_name = SwissKnife::Helpers::ACTION_ALIASES[controller.action_name] || controller.action_name

      @_page_title_options ||= {}
      options = @_page_title_options[:options] || {}
      title = @_page_title_options[:title]
      title ||= t("titles.#{controller_name}.#{action_name}", options)
      title
    end
  end
end
