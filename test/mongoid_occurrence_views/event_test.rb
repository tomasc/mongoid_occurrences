require "test_helper"

describe MongoidOccurrenceViews::Event do
  subject { DummyEvent.new }

  describe 'fields' do
  end

  describe 'relations' do
    it { subject.must_respond_to :occurrences }
  end

  describe '.occurrences_view_name' do
    it { subject.class.occurrences_view_name.must_equal 'dummy_events__occurrences_view' }
  end

  describe '.expanded_occurrences_view_name' do
    it { subject.class.expanded_occurrences_view_name.must_equal 'dummy_events__expanded_occurrences_view' }
  end

  describe 'views' do
    it { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten.must_include subject.class.occurrences_view_name }
    it { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten.must_include subject.class.expanded_occurrences_view_name }

    let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
    let(:end_date) { DateTime.parse('26/08/2018 21:00 +0200') }
    let(:occurrence_recurring) { DummyOccurrence.new(dtstart: start_date, dtend: end_date) }
    let(:dummy_event) { DummyEvent.new(occurrences: [occurrence_recurring]) }

    before { dummy_event.save! }

    it { DummyEvent.all.length.must_equal 1 }

    describe '.with_occurrences_view' do
      it { DummyEvent.with_occurrences_view { DummyEvent.pluck(:_dtstart).must_equal [start_date, (start_date + 1.day).beginning_of_day, (start_date + 2.day).beginning_of_day, (start_date + 3.day).beginning_of_day, (start_date + 4.day).beginning_of_day, (start_date + 5.day).beginning_of_day, (start_date + 6.day).beginning_of_day] } }
    end

    describe '.with_expanded_occurrences_view' do
      it { DummyEvent.with_expanded_occurrences_view { DummyEvent.all.length.must_equal 7 } }
    end
  end
end
