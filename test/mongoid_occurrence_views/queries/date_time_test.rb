require 'test_helper'

describe 'Querying Events' do
  let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
  let(:end_date) { start_date + 2.hours }
  let(:all_day) { false }
  let(:schedule) { nil }
  let(:occurrence) { Occurrence.new(dtstart: start_date, dtend: end_date, all_day: all_day, schedule: schedule) }
  let(:event) { Event.new(occurrences: [occurrence]) }

  let(:query_date) { start_date }
  let(:query) { MongoidOccurrenceViews::Queries::DateTime.criteria(Event, query_date) }

  before { event.save! }

  describe 'spanning one day' do
    it { query.count.must_equal 1 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    # TODO: TBD when we know if the normal occurrences view is needed
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  describe 'spanning multiple days' do
    let(:end_date) { start_date + 2.days }
    let(:query_date) { start_date + 1.day }

    it { query.count.must_equal 1 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    # TODO: TBD when we know if the normal occurrences view is needed
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  describe 'recurring' do
    let(:schedule) { IceCube::Schedule.new(start_date.to_time) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }
    let(:query_date) { start_date + 4.days }

    it { query.count.must_equal 1 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    # TODO: TBD when we know if the normal occurrences view is needed
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  private

  def within_occurrences(&block)
    Event.within_occurrences(&block)
  end

  def within_expanded_occurrences(&block)
    Event.within_expanded_occurrences(&block)
  end
end

describe 'Querying Parent with Embedded Events' do
  let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
  let(:end_date) { start_date + 2.hours }
  let(:all_day) { false }
  let(:schedule) { nil }
  let(:occurrence) { Occurrence.new(dtstart: start_date, dtend: end_date, all_day: all_day, schedule: schedule) }
  let(:embedded_event) { EmbeddedEvent.new(occurrences: [occurrence]) }
  let(:event_parent) { EventParent.new(embedded_events: [embedded_event]) }

  let(:query_date) { start_date }
  let(:query) { MongoidOccurrenceViews::Queries::DateTime.criteria(EventParent, query_date) }

  before { event_parent.save! }

  describe 'spanning one day' do
    it { query.count.must_equal 0 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    # TODO: TBD when we know if the normal occurrences view is needed
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  describe 'spanning multiple days' do
    let(:end_date) { start_date + 2.days }
    let(:query_date) { start_date + 1.day }

    it { query.count.must_equal 0 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    # TODO: TBD when we know if the normal occurrences view is needed
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  describe 'recurring' do
    let(:schedule) { IceCube::Schedule.new(start_date.to_time) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }
    let(:query_date) { start_date + 4.days }

    it { query.count.must_equal 0 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    # TODO: TBD when we know if the normal occurrences view is needed
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  private

  def within_occurrences(&block)
    EventParent.within_occurrences(&block)
  end

  def within_expanded_occurrences(&block)
    EventParent.within_expanded_occurrences(&block)
  end
end
