module RailsTools
  module Helper
    def flash_messages
      html = ""

      flash.each do |name, message|
        html << content_tag(:p, message, :class => "message #{name}")
        flash.discard(name)
      end

      safe_html(html)
    end

    def rails_meta_tags
      controller_name = controller.class.name.underscore
      controller_name.gsub!(/\//, "_")
      controller_name.gsub!(/_controller$/, "")

      safe_html %[
        <meta name="rails-controller" content="#{controller_name}" />
    	  <meta name="rails-action" content="#{controller.action_name}" />
    	]
    end

    def body(options = {}, &block)
      options = {
        :id => "#{controller.controller_name}-page",
        :class => "#{controller.controller_name}-#{controller.action_name} #{I18n.locale}"
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