module SwissKnife
  module RSpec
    module Matchers
      def allow(*values)
        Allow.new(values)
      end

      class Allow
        attr_accessor :values, :record, :failed, :attribute

        def initialize(values)
          @failed = []
          @values = values
        end

        def matches?(record)
          @record = record
          matches_against?(false)
        end

        def does_not_match?(record)
          @record = record
          matches_against?(true)
        end

        def description
          "allow #{values.inspect} as #{attribute}"
        end

        def failure_message
          "expected #{record.inspect} to allow each of #{values.inspect} as #{attribute.inspect} value (didn't accept #{failed.inspect})"
        end

        def negative_failure_message
          "expected #{record.inspect} to reject each of #{values.inspect} as #{attribute.inspect} value (accepted #{failed.inspect})"
        end

        def for(attribute)
          @attribute = attribute
          self
        end

        def matches_against?(compare)
          raise "The allow matcher requires an attribute; use subject.should allow(*values).as(attribute)" unless attribute

          values.each do |value|
            record.__send__("#{attribute}=", value)
            record.valid?
            failed << value if record.errors[attribute].empty? == compare
          end

          failed.empty?
        end
      end
    end
  end
end
