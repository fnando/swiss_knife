module SwissKnife
  module Helpers
    ACTION_ALIASES = {
      "create" => "new",
      "update" => "edit",
      "remove" => "destroy"
    }

    DEFAULT_GRAVATARS = [:mm, :identicon, :monsterid, :wavatar, :retro, 404]
    GRAVATAR_HOST = "https://secure.gravatar.com/avatar/"

    # Display gravatar images.
    #
    #   <%= gravatar "cb5d9e9095cd41b636764a85e57ade4b" %>
    #   <%= gravatar user.email, :alt => user.name, :size => 80 %>
    #   <%= gravatar user.email, :title => user.name %>
    #   <%= gravatar user.email, :rating => :g %>
    #   <%= gravatar user.email, :default => :mm %>
    #   <%= gravatar user.email, :default => "gravatar.jpg" %>
    #   <%= gravatar user.email, :ssl => true %>
    #
    #
    def gravatar_tag(email, options = {})
      email = Digest::MD5.hexdigest(email) unless email =~ /^[a-z0-9]{32}$/i
      options.reverse_merge!(
        :rating  => :g,
        :default => "gravatar.jpg",
        :size    => 32
      )

      params = {
        :s => options[:size],
        :r => options[:rating],
        :d => DEFAULT_GRAVATARS.include?(options[:default]) ?
                                          options[:default] :
                                          asset_path(options[:default])
      }

      url = String.new.tap do |s|
        s << GRAVATAR_HOST
        s << email.to_s << ".jpg"
        s << "?"
        s << params.collect {|k, v| v.to_s.to_query(k) }.join("&")
      end

      image_tag url, class: "gravatar", alt: options[:alt], title: options[:title]
    end

    # Display flash messages.
    #
    #   flash_messages
    #   #=> '<p class="message alert">This is just an alert!</p>
    #
    def flash_messages
      safe_buffer do |html|
        flash.each do |name, message|
          html << content_tag(:p, message, :class => "message #{name}")
          flash.discard(name)
        end
      end
    end

    # Wrap the content in a <BODY> tag.
    #
    #   <%= body do %>
    #     <h1>Hi there!</h1>
    #   <% end %>
    #
    # This will set some attributes like <tt>id</tt> and <tt>class</tt>,
    # with controller and action name.
    #
    # You can set additional CSS classes by using the <tt>:append_class</tt> option.
    #
    #   body(:append_class => "theme-red") { ...some content }
    #
    def body(options = {}, &block)
      action_name = ACTION_ALIASES[controller.action_name] || controller.action_name
      controller_name_for_css_class = controller.controller_name.gsub(/\_/, "-")

      options = {
        :id => "#{controller_name_for_css_class}-page",
        :class => [
          "#{controller_name_for_css_class}-#{action_name}",
          "#{controller_name_for_css_class}-#{controller.action_name}",
          I18n.locale,
          Rails.env
        ].uniq.join(" ")
      }.merge(options)

      options[:class] << (" " + options.delete(:append_class).to_s) if options[:append_class]

      content_tag(:body, capture(&block), options).html_safe
    end

    def page(options = {}, &block)
      wrapper(:div, options.merge(:id => "page"), &block)
    end

    def main(options = {}, &block)
      wrapper(:div, options.merge(:id => "main"), &block)
    end

    def sidebar(options = {}, &block)
      wrapper(:sidebar, options, &block)
    end

    def header(options = {}, &block)
      wrapper(:header, options, &block)
    end

    def footer(options = {}, &block)
      wrapper(:footer, options, &block)
    end

    def article(options = {}, &block)
      wrapper(:article, options, &block)
    end

    def section(options = {}, &block)
      wrapper(:section, options, &block)
    end

    def wrapper(tag, options = {}, &block)
      content_tag(tag, capture(&block), options)
    end

    def fieldset(legend, options = {}, &block)
      legend = t(legend, :default => legend.to_s)

      content_tag(:fieldset, options) do
        body = content_tag(:legend, legend)
        body << yield.to_s.html_safe
        body
      end
    end

    # Create a submit button with a cancel link besides.
    #
    #   submit_or_cancel root_path
    #   submit_or_cancel root_path, :button => "Save"
    #   submit_or_cancel root_path, :button => :"some.scope.for.button"
    #   submit_or_cancel root_path, :cancel => "Go back"
    #   submit_or_cancel root_path, :cancel => :"some.scope.for.link"
    #
    def submit_or_cancel(url, options = {})
      options.reverse_merge!(:button => :"swiss_knife.submit", :cancel => :"swiss_knife.cancel")

      safe_buffer do |html|
        html << submit_tag(t(options[:button], :default => options[:button]), :class => "button")
        html << " "
        html << link_to(t(options[:cancel], :default => options[:cancel]), url, :class => "cancel")
      end
    end

    # Return a string marked as safe html.
    #
    # Change the buffer object when block expects one argument.
    #
    #   safe_buffer {|html| html << "<p>Some content</p>"}
    #
    # Use block's return when block expects no argument.
    #
    #   safe_buffer { "<p>Some content</p>" }
    #
    # Get a safe buffer object.
    #
    #   buffer = safe_buffer
    #
    def safe_buffer(&block)
      buffer = ActiveSupport::SafeBuffer.new

      if block_given?
        if block.arity == 1
          yield buffer
        else
          buffer = yield(buffer)
        end
      end

      buffer.html_safe
    end

    private

    def controller_name
      unless @controller_name
        @controller_name = controller.class.name.underscore
        @controller_name.gsub!(/\//, "_")
        @controller_name.gsub!(/_controller$/, "")
      end

      @controller_name
    end
  end
end
