require "test_helper"

describe MongoidOccurrenceViews::Event do
  let(:event) { DummyEvent.new }

  describe 'relations' do
    it { event.must_respond_to :occurrences }
  end

  describe 'scopes' do
    let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
    let(:end_date) { start_date + 2.days }
    let(:occurrence) { DummyOccurrence.new(dtstart: start_date, dtend: end_date, all_day: false) }
    let(:event) { DummyEvent.new(occurrences: [occurrence])  }

    before { event.save! }

    it { DummyEvent.for_date_time_range(start_date, end_date).to_a.must_include event }
    it { DummyEvent.for_date_time_range(start_date, end_date).count.must_equal 1 }
    it { with_view { DummyEvent.for_date_time_range(start_date, end_date).to_a.must_include event } }
    it { with_view { DummyEvent.for_date_time_range(start_date, end_date - 1.day).count.must_equal 2 } }
  end

  describe '.occurrences_view_name' do
    it { event.class.occurrences_view_name.must_equal 'dummy_events__occurrences_view' }
  end

  describe '.expanded_occurrences_view_name' do
    it { event.class.expanded_occurrences_view_name.must_equal 'dummy_events__expanded_occurrences_view' }
  end

  describe 'views' do
    let(:collection_names) { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten }

    it { collection_names.must_include event.class.occurrences_view_name }
    it { collection_names.must_include event.class.expanded_occurrences_view_name }
  end

  private

  def with_view(&block)
    DummyEvent.with_expanded_occurrences_view(&block)
  end
end
