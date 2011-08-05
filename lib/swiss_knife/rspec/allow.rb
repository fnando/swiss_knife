RSpec::Matchers.define :allow do |*values|
  @failed = []
  @values = values

  match_for_should do |record|
    @record = record
    matches_against?(false)
  end

  match_for_should_not do |record|
    @record = record
    matches_against?(true)
  end

  def matches_against?(compare)
    raise "The allow matcher requires an attribute; use subject.should allow(*values).as(attribute)" unless @attribute

    @values.each do |value|
      @record.__send__("#{@attribute}=", value)
      @record.valid?
      @failed << value if @record.errors[@attribute].empty? == compare
    end

    @failed.empty?
  end

  failure_message_for_should do |actual|
    "expected #{@record.inspect} to allow each of #{@values.inspect} as #{@attribute.inspect} value (didn't accept #{@failed.inspect})"
  end

  failure_message_for_should_not do |actual|
    "expected #{@record.inspect} to reject each of #{@values.inspect} as #{@attribute.inspect} value (accepted #{@failed.inspect})"
  end

  chain :as do |attribute|
    @attribute = attribute
  end

  description do
    "allow #{values.inspect} as #{@attribute}"
  end
end
