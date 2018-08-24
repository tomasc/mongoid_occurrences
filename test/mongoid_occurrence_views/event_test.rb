require "test_helper"

describe MongoidOccurrenceViews::Event do
  let(:event) { build(:event, :today) }

  it { event.must_respond_to :occurrences }
end
