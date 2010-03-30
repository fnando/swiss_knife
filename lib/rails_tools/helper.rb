module RailsTools
  module Helper
    ACTION_ALIASES = {
      "create" => "new",
      "update" => "edit",
      "destroy" => "remove"
    }

    def flash_messages
      html = ""

      flash.each do |name, message|
        html << content_tag(:p, message, :class => "message #{name}")
        flash.discard(name)
      end

      safe_html(html)
    end

    def dispatcher_tag
      controller_name = controller.class.name.underscore
      controller_name.gsub!(/\//, "_")
      controller_name.gsub!(/_controller$/, "")

      safe_html %[<meta name="page" content="#{controller_name}##{controller.action_name}" />]
    end

    def body(options = {}, &block)
      action_name = ACTION_ALIASES[controller.action_name] || controller.action_name

      options = {
        :id => "#{controller.controller_name}-page",
        :class => "#{controller.controller_name}-#{action_name} #{I18n.locale}"
      }.merge(options)

      concat safe_html(content_tag(:body, capture(&block), options))
    end

    def main(options = {}, &block)
      wrapper(options.merge(:id => "main"), &block)
    end

    def sidebar(options = {}, &block)
      wrapper(options.merge(:id => "sidebar"), &block)
    end

    def header(options = {}, &block)
      wrapper(options.merge(:id => "header"), &block)
    end

    def footer(options = {}, &block)
      wrapper(options.merge(:id => "footer"), &block)
    end

    def wrapper(options = {}, &block)
      concat safe_html(content_tag(:div, capture(&block), options))
    end

    def mail_to(email, label = nil)
      encrypt = proc do |text|
        text.to_enum(:each_byte).collect {|c| sprintf("&#%d;", c) }.join
      end

      url = safe_html encrypt.call("mailto:#{email}")
      label ||= safe_html encrypt.call(email)

      safe_html link_to(label, url)
    end

    def javascript_includes(*args)
      options = args.extract_options!
      html = ""

      args.each do |name|
        bundle = RailsTools::Assets.config["javascripts"][name.to_s] rescue nil

        if RailsTools::Assets.merge? && bundle
          html << javascript_include_tag("#{name}_packaged", options)
        elsif bundle
          bundle.each do |file|
            html << javascript_include_tag("#{file}", options)
          end
        else
          html << javascript_include_tag("#{name}", options)
        end
      end

      safe_html(html)
    end

    def stylesheet_includes(*args)
      options = args.extract_options!
      html = ""

      args.each do |name|
        bundle = RailsTools::Assets.config["stylesheets"][name.to_s] rescue nil

        if RailsTools::Assets.merge? && bundle
          html << stylesheet_link_tag("#{name}_packaged", options)
        elsif bundle
          bundle.each do |file|
            html << stylesheet_link_tag("#{file}", options)
          end
        else
          html << stylesheet_link_tag("#{name}", options)
        end
      end

      safe_html(html)
    end

    def safe_html(html)
      if html.respond_to?(:html_safe)
        html.html_safe
      elsif html.respond_to?(:html_safe!)
        html.html_safe!
      else
        html
      end
    end
  end
end