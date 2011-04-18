module SwissKnife
  module RSpec
    module Matchers
      def allow(value, *values)
        Allow.new(value, *values)
      end

      class Allow
        attr_reader :values, :attribute, :record

        def initialize(*values)
          @values = values
        end

        def matches?(record)
          @record = record

          values.collect {|value|
            record.send("#{attribute}=", value)
            record.valid?
            record.errors[attribute].empty?
          }.all?
        end

        def as(attribute)
          @attribute = attribute
          self
        end

        def description
          "allow #{values.inspect} values for #{attribute.inspect} attribute"
        end

        def failure_message
          "expected #{record.inspect} to allow each of #{values.inspect} as #{attribute.inspect} value"
        end

        def negative_failure_message
          "expected #{record.inspect} to reject each of #{values.inspect} as #{attribute.inspect} value"
        end
      end
    end
  end
end
