require 'test_helper'

describe MongoidOccurrences::Aggregations::OccursUntil do
  let(:occurrence_today) { build(:occurrence, :today) }
  let(:occurrence_tomorrow) { build(:occurrence, :tomorrow) }
  let(:event) { build :event, occurrences: [occurrence_today, occurrence_tomorrow] }

  before { event.save! }

  it { subject.instantiate(Event.criteria, occurrence_today.dtend).size.must_equal 1 }
  it { subject.instantiate(Event.criteria, occurrence_today.dtend).must_include event }

  it { subject.instantiate(Event.criteria, occurrence_tomorrow.dtend).size.must_equal 2 }
  it { subject.instantiate(Event.criteria, occurrence_tomorrow.dtend).must_include event }

  it { subject.instantiate(Event.criteria, occurrence_tomorrow.dtend + 1.day).size.must_equal 2 }
  it { subject.instantiate(Event.criteria, occurrence_tomorrow.dtend + 1.day).must_include event }

  it { subject.instantiate(Event.criteria, occurrence_today.dtstart - 1.day).wont_include event }

  describe 'dtstart & dtend' do
    let(:instantiated_event_today) { subject.instantiate(Event.criteria, occurrence_tomorrow.dtend)[0] }
    let(:instantiated_event_tomorrow) { subject.instantiate(Event.criteria, occurrence_tomorrow.dtend)[1] }

    it { instantiated_event_today.dtstart.must_equal occurrence_today.dtstart }
    it { instantiated_event_today.dtend.must_equal occurrence_today.dtend }

    it { instantiated_event_tomorrow.dtstart.must_equal occurrence_tomorrow.dtstart }
    it { instantiated_event_tomorrow.dtend.must_equal occurrence_tomorrow.dtend }
  end
end
