require 'test_helper'

describe MongoidOccurrences::DailyOccurrence::HasScopes do
  subject { MongoidOccurrences::DailyOccurrence }

  it { _(subject).must_respond_to :occurs_between }
  it { _(subject).must_respond_to :occurs_from }
  it { _(subject).must_respond_to :occurs_on }
  it { _(subject).must_respond_to :occurs_until }
end
