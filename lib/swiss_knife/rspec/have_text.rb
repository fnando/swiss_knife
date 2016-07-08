module SwissKnife
  module RSpec
    module Matchers
      def have_text(matcher)
        HaveText.new(matcher)
      end

      class HaveText
        attr_accessor :matcher, :subject, :regex

        def initialize(matcher)
          @matcher = matcher
        end

        def matches?(text)
          @subject = text.to_s

          case matcher
          when String
            subject.index(matcher)
          when Regexp
            subject.match(matcher)
          end
        end

        def description
          "have text #{matcher.inspect}"
        end

        def failure_message
          "expected #{subject.inspect} to include #{matcher.inspect}"
        end

        def failure_message_when_negated
          "expected #{subject.inspect} to exclude #{matcher.inspect}"
        end
      end
    end
  end
end
