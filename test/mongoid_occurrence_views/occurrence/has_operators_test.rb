require 'test_helper'

describe MongoidOccurrenceViews::Occurrence::HasOperators do
  let(:subject) { ::Occurrence }
  let(:occurrence) { build :occurrence }

  it { subject.must_respond_to :with_operators }

  it { occurrence.must_respond_to :operator }
  it { occurrence.operator.must_equal :append }
end
