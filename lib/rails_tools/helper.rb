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