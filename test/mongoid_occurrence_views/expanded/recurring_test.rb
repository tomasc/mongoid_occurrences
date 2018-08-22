require 'test_helper'

describe 'Query Expanded defined by recurring schedule' do
  let(:all_day) { false }
  let(:schedule) { nil }
  let(:occurrence) { DummyOccurrence.new(dtstart: start_date, dtend: end_date, all_day: all_day, schedule: schedule) }
  let(:event) { DummyEvent.new(occurrences: [occurrence]) }

  before { event.save! }

  # TODO: cleanup according to range_test
  # let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
  # let(:end_date) { DateTime.parse('20/08/2018 12:00 +0200') }
  # let(:schedule) { IceCube::Schedule.new(start_date.to_time) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }
  #
  # it { with_view { DummyEvent.all.length.must_equal 7 } }
  # it { with_view { DummyEvent.pluck(:_dtstart).must_equal 7.times.map{ |i| start_date + i.day } } }
  #
  # describe 'all_day' do
  #   let(:all_day) { true }
  #
  #   it { with_view { DummyEvent.all.length.must_equal 7 } }
  #   it { with_view { DummyEvent.pluck(:_dtstart).must_equal 7.times.map{ |i| (start_date + i.day).beginning_of_day } } }
  #   it { with_view { DummyEvent.pluck(:_dtend).must_equal 7.times.map{ |i| (start_date + i.day).end_of_day } } }
  # end

  # TODO: extract to separate file
  # describe 'with multiple occurrences' do
  #   let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
  #   let(:end_date) { DateTime.parse('20/08/2018 21:00 +0200') }
  #   let(:second_start_date) { DateTime.parse('21/08/2018 10:00 +0200') }
  #   let(:second_end_date) { DateTime.parse('24/08/2018 12:00 +0200') }
  #   let(:second_occurrence) { DummyOccurrence.new(dtstart: second_start_date, dtend: second_end_date, all_day: all_day, schedule: schedule) }
  #   let(:event) { DummyEvent.new(occurrences: [occurrence, second_occurrence]) }
  #
  #   it { with_view { DummyEvent.all.length.must_equal 5 } }
  #   it { with_view { DummyEvent.pluck(:_dtstart).must_equal [ start_date, second_start_date, (second_start_date + 1.day).beginning_of_day, (second_start_date + 2.day).beginning_of_day, (second_start_date + 3.day).beginning_of_day ] } }
  # end

  private

  def with_view(&block)
    DummyEvent.with_expanded_occurrences_view(&block)
  end
end
