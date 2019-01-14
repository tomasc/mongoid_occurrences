require 'test_helper'

describe MongoidOccurrenceViews::Occurrence::HasScopes do
  subject { ::Occurrence }

  it { subject.must_respond_to :occurs_between }
  it { subject.must_respond_to :occurs_from }
  it { subject.must_respond_to :occurs_on }
  it { subject.must_respond_to :occurs_until }
end
