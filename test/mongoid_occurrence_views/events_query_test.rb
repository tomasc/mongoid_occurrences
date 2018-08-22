require 'test_helper'

describe 'Queries for events' do
  let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
  let(:end_date) { DateTime.parse('26/08/2018 21:00 +0200') }
  let(:occurrence_recurring) { DummyOccurrence.new(dtstart: start_date, dtend: end_date) }
  let(:dummy_event) { DummyEvent.new(occurrences: [occurrence_recurring]) }

  before { dummy_event.save! }

  it { DummyEvent.all.length.must_equal 1 }
  it { DummyEvent.with_occurrences_view { DummyEvent.pluck(:_dtstart).must_equal [start_date, (start_date + 1.day).beginning_of_day, (start_date + 2.day).beginning_of_day, (start_date + 3.day).beginning_of_day, (start_date + 4.day).beginning_of_day, (start_date + 5.day).beginning_of_day, (start_date + 6.day).beginning_of_day] } }
end
