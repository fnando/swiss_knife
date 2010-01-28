module RailsTools
  module Helper
    def flash_messages
      html = ""

      flash.each do |name, message|
        html << content_tag(:p, message, :class => "message #{name}")
        flash.discard(name)
      end

      html.respond_to?(:html_safe!) ? html.html_safe! : html
    end

    def rails_meta_tags
      %[
        <meta name="rails-controller" content="#{controller.controller_name}" />
    	  <meta name="rails-action" content="#{controller.action_name}" />
    	]
    end

    def body(options = {}, &block)
      options = {
        :id => "#{controller.controller_name}-page",
        :class => "#{controller.controller_name}-#{controller.action_name}"
      }.merge(options)

      content_tag :body, capture(&block), options
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
      content_tag :div, capture(&block), options
    end
  end
end