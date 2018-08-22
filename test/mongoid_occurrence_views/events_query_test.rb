require 'test_helper'

describe 'Queries for events' do
  let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
  let(:end_date) { start_date + 4.days }
  let(:all_day) { false }
  let(:occurrence) { DummyOccurrence.new(dtstart: start_date, dtend: end_date, all_day: all_day) }
  let(:event) { DummyEvent.new(occurrences: [occurrence]) }

  before { event.save! }

  it { with_view { DummyEvent.where(id: event.id).for_date_time_range(start_date, end_date).count.must_equal 5 } }

  private

  def with_view(&block)
    DummyEvent.with_occurrences_view(&block)
  end
end
