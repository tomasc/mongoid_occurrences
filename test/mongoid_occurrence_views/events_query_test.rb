require 'test_helper'

describe 'Queries for events' do
  let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
  let(:end_date) { DateTime.parse('26/08/2018 21:00 +0200') }
  let(:occurrence_recurring) { DummyOccurrence.new(dtstart: start_date, dtend: end_date) }
  let(:dummy_event) { DummyEvent.new(occurrences: [occurrence_recurring]) }

  before { dummy_event.save! }

  it { with_view { DummyEvent.all.length.must_equal 1 } }
  it { with_view { DummyEvent.pluck(:_dtstart).must_equal 7.times.map{ |i| start_date + (i-1).day } } }

  private

  def with_view(&block)
    DummyEvent.with_occurrences_view &block
  end
end
