require 'test_helper'

describe MongoidOccurrences::Aggregations::OccursOn do
  let(:occurrence_today) { build(:occurrence, :today) }
  let(:occurrence_tomorrow) { build(:occurrence, :tomorrow) }
  let(:event) { build :event, occurrences: [occurrence_today, occurrence_tomorrow] }

  before { event.save! }

  it { _(subject.instantiate(Event.criteria, occurrence_today.dtstart.to_date).size).must_equal 1 }
  it { _(subject.instantiate(Event.criteria, occurrence_today.dtstart.to_date)).must_include event }

  it { _(subject.instantiate(Event.criteria, occurrence_tomorrow.dtstart.to_date).size).must_equal 1 }
  it { _(subject.instantiate(Event.criteria, occurrence_tomorrow.dtstart.to_date)).must_include event }

  it { _(subject.instantiate(Event.criteria, occurrence_tomorrow.dtstart.to_date + 1.day)).wont_include event }

  describe 'dtstart & dtend' do
    let(:instantiated_event_today) { subject.instantiate(Event.criteria, occurrence_today.dtstart)[0] }
    let(:instantiated_event_tomorrow) { subject.instantiate(Event.criteria, occurrence_tomorrow.dtstart)[0] }

    it { _(instantiated_event_today.dtstart).must_equal occurrence_today.dtstart }
    it { _(instantiated_event_today.dtend).must_equal occurrence_today.dtend }

    it { _(instantiated_event_tomorrow.dtstart).must_equal occurrence_tomorrow.dtstart }
    it { _(instantiated_event_tomorrow.dtend).must_equal occurrence_tomorrow.dtend }
  end
end
