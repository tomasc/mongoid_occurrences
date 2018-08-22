require 'test_helper'

describe 'Queries for Expanded events' do
  let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
  let(:end_date) { DateTime.parse('26/08/2018 21:00 +0200') }
  let(:occurrence_recurring) { DummyOccurrence.new(dtstart: start_date, dtend: end_date) }
  let(:dummy_event) { DummyEvent.new(occurrences: [occurrence_recurring]) }

  before { dummy_event.save! }

  it { with_view { DummyEvent.all.length.must_equal 7 } }
  it { with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date].push(6.times.map{ |i| (start_date + (i+1).day).beginning_of_day }).flatten } }

  private

  def with_view(&block)
    DummyEvent.with_expanded_occurrences_view(&block)
  end
end
