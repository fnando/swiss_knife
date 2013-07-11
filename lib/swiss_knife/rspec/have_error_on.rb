module SwissKnife
  module RSpec
    module Matchers
      def have_error_on(attribute)
        HaveErrorOn.new(attribute)
      end

      alias_method :have_errors_on, :have_error_on

      class HaveErrorOn
        attr_accessor :attribute, :subject

        def initialize(attribute)
          @attribute = attribute
        end

        def matches?(subject)
          @subject = subject
          subject.errors[attribute.to_sym].any?
        end

        def description
          "have errors on #{attribute.inspect}"
        end

        def failure_message
          "expected #{subject.inspect} to have errors on #{attribute.inspect}"
        end

        def negative_failure_message
          "expected #{subject.inspect} to have no errors on #{attribute.inspect}"
        end
      end
    end
  end
end
