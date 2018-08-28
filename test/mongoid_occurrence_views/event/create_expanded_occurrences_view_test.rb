require 'test_helper'

describe MongoidOccurrenceViews::Event::CreateExpandedOccurrencesView do
  let(:view) { subject.new(klass) }
  let(:yesterday) { build :occurrence, :yesterday }
  let(:today) { build :occurrence, :today }
  let(:tomorrow) { build :occurrence, :tomorrow }
  let(:last_week) { build :occurrence, :last_week }
  let(:next_week) { build :occurrence, :next_week }
  let(:occurrences) { [tomorrow, last_week, today, yesterday, next_week].shuffle }

  describe '#pipeline' do
    let(:pipeline) { view.pipeline }
    let(:aggregation) { klass.collection.aggregate(pipeline) }

    describe 'Events' do
      let(:klass) { Event }

      before { create :event, occurrences: occurrences }

      let(:_dtstarts) { klass.collection.aggregate(pipeline).to_a.pluck(:_dtstart) }
      let(:_dtends) { klass.collection.aggregate(pipeline).to_a.pluck(:_dtend) }

      it { aggregation.to_a.length.must_equal 5 }
      it { _dtstarts.map { |ds| DateTime.demongoize(ds) }.must_equal occurrences.map(&:dtstart) }
      it { _dtends.map { |ds| DateTime.demongoize(ds) }.must_equal occurrences.map(&:dtend) }
    end

    describe 'EventParents' do
      let(:klass) { EventParent }
      let(:embedded_event) { build :embedded_event, occurrences: occurrences }

      before { create :event_parent, embedded_events: [embedded_event] }

      let(:_dtstarts) { klass.collection.aggregate(pipeline).to_a.pluck(:_dtstart) }
      let(:_dtends) { klass.collection.aggregate(pipeline).to_a.pluck(:_dtend) }

      it { aggregation.to_a.length.must_equal 5 }
      it { _dtstarts.map { |ds| DateTime.demongoize(ds) }.must_equal occurrences.map(&:dtstart) }
      it { _dtends.map { |ds| DateTime.demongoize(ds) }.must_equal occurrences.map(&:dtend) }
    end
  end
end
