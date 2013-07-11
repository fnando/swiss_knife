module SwissKnife
  module Helpers
    ACTION_ALIASES = {
      "create" => "new",
      "update" => "edit",
      "remove" => "destroy"
    }

    DEFAULT_GRAVATARS = [:mm, :identicon, :monsterid, :wavatar, :retro, 404]
    GRAVATAR_URLS = {
      :http  => "http://www.gravatar.com/avatar/",
      :https => "https://secure.gravatar.com/avatar/"
    }

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
        :ssl     => request.ssl?,
        :size    => 32
      )

      params = {
        :r => options[:rating],
        :d => DEFAULT_GRAVATARS.include?(options[:default]) ?
          options[:default] : compute_public_path(options[:default], "images", nil, true),
        :s => options[:size]
      }

      url = String.new.tap do |s|
        s << (options[:ssl] ? GRAVATAR_URLS[:https] : GRAVATAR_URLS[:http])
        s << email.to_s << ".jpg"
        s << "?"
        s << params.collect {|k, v| v.to_s.to_query(k) }.join("&")
      end

      image_tag url, { :class => "gravatar", :alt => options[:alt], :title => options[:title] }
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

    # Create a meta tag for http://github.com/fnando/dispatcher-js.
    #
    #   <%= dispatcher %>
    #
    def dispatcher_tag
      %[<meta name="page" content="#{controller_name}##{controller.action_name}" />].html_safe
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
      controller_name_for_css_class = controller_name.gsub(/\_/, "-")

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

    def javascript_includes(*args)
      options = args.extract_options!

      safe_buffer do |html|
        args.each do |name|
          bundle = SwissKnife::Assets.config["javascripts"][name.to_s] rescue nil

          if SwissKnife::Assets.merge? && bundle
            html << javascript_include_tag("#{name}_packaged".html_safe, options)
          elsif bundle
            bundle.each do |file|
              html << javascript_include_tag(file.to_s.html_safe, options)
            end
          else
            html << javascript_include_tag(name.to_s.html_safe, options)
          end
        end
      end
    end

    def stylesheet_includes(*args)
      options = args.extract_options!

      safe_buffer do |html|
        args.each do |name|
          bundle = SwissKnife::Assets.config["stylesheets"][name.to_s] rescue nil

          if SwissKnife::Assets.merge? && bundle
            html << stylesheet_link_tag("#{name}_packaged", options)
          elsif bundle
            bundle.each do |file|
              html << stylesheet_link_tag("#{file}", options)
            end
          else
            html << stylesheet_link_tag("#{name}", options)
          end
        end
      end
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

    # Load jQuery from Google's CDN and if the world is collapsing and Google is down,
    # load it locally.
    #
    #   jquery_script_tag #=> Default to 1.6.3
    #   jquery_script_tag("1.4.2")
    #
    # The local version should be placed at <tt>public/javascripts/jquery-%{version}.min.js</tt>.
    #
    def jquery_script_tag(version = "1.6.3")
      target = respond_to?(:compute_public_path) ? self : asset_paths
      local_path = target.__send__(:compute_public_path, "jquery-#{version}.min.js", "javascripts")
      remote_path = "#{request.protocol}ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js"

      safe_buffer do
        %[
      		<script type="text/javascript" src="#{remote_path}"></script>
      		<script type="text/javascript">
      			if (typeof jQuery === "undefined") {
      				document.write(unescape("%3Cscript src='#{local_path}' type='text/javascript'%3E%3C/script%3E"));
      			};
      		</script>
        ]
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
