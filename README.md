# Swiss Knife

Lots of Rails helpers that I use on my own projects.

## Usage

### body(&block)

Create the `body` tag setting some attributes:

    <%= body do %>
    <% end %>

Will be converted to

    <body id="sample-page" class="sample-index en">
    </body>

Set any attribute by providing a hash:

    <%= body id: "foo", class: "bar", onload: "init();" do %>
    <% end %>

If you just want to append more classes, use the options `:append_class`:

    <%= body append_class: 'foo' do %>
    <% end %>

### flash_messages

Display all flash messages in `<p class="message #{type}"></p>` tags.
So if you set messages like

    flash[:notice] = "Notice"

you can add this to your view

    <%= flash_messages %>

and the helper will output

    <p class="message notice">Notice</p>

### Block wrappers

Just hiding some HTML.

    <%= main do %>
    <!-- Wrap the content into a div#main tag -->
    <% end %>

    <%= sidebar do %>
    <!-- Wrap the content into a sidebar tag -->
    <% end %>

There's also `page`, `section`, `article`, `header`, and `footer` wrappers. You can set other attributes, like CSS classes:

    <%= main class: "rounded" do %>
    <% end %>

### fieldset

A fieldset helper with I18n support.

    <%= fieldset "labels.user.create" do %>
    <!-- Some html -->
    <% end %>

### gravatar_tag

    gravatar_tag user.email
    gravatar_tag "098f6bcd4621d373cade4e832627b4f6"
    gravatar_tag user.email, :size => 80
    gravatar_tag user.email, :rating => :x

    # Predefined default images provided by Gravatar. Can be
    # :mm, :identicon, :monsterid, :wavatar, :retro, 404
    gravatar_tag user.email, :default => :mm

    gravatar_tag user.email, :default => "gravatar.png"
    gravatar_tag user.email, :alt => user.name
    gravatar_tag user.email, :title => user.name

### submit_or_cancel

    submit_or_cancel root_path
    submit_or_cancel root_path :button => "Save"
    submit_or_cancel root_path :button => :"some.scope.for.save"
    submit_or_cancel root_path :cancel => "Go back"
    submit_or_cancel root_path :cancel => :"some.scope.for.go_back"

### RSpec

Swiss Knife includes some RSpec matchers. To use them, add the following like to your `spec_helper.rb` file:

    require "swiss_knife/rspec"

#### have_tag and have_node

The `have_tag` matcher uses Nokogiri, so you can use any CSS selector accepted by Nokogiri to filter elements.

    expect(html).to have_tag("p", "Hello world!")
    expect(html).to have_tag("p", text: "Hello world!")
    expect(html).to have_tag("p", count: 1)
    expect(html).to have_tag("p", maximum: 3)
    expect(html).to have_tag("p", minimum: 3)
    expect(html).to have_tag("form") do |form|
      expect(form).to have_tag("input.submit", count: 1)
    end

If you're inspecting some XML snippet, you can use the `have_node` matcher.

#### have_text

    expect(string).to have_text("Lorem ipsum")
    expect(string).to have_text(/Lorem ipsum/)

#### allow

    expect(record).to allow("john@doe.com").as(:email)
    expect(record).to allow(nil, "").as(:email)

## Maintainer

* Nando Vieira (<http://nandovieira.com>)

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
