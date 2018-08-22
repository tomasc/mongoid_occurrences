require 'test_helper'

describe 'Query Expanded defined by recurring schedule' do
  let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
  let(:end_date) { start_date + 2.hours }
  let(:schedule) { IceCube::Schedule.new(start_date.to_time) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }
  let(:occurrence) { DummyOccurrence.new(dtstart: start_date, dtend: end_date, schedule: schedule) }
  let(:event) { DummyEvent.new(occurrences: [occurrence]) }

  before { event.save! }

  it { with_view { DummyEvent.where(id: event.id).count.must_equal 7 } }
  it { with_view { DummyEvent.where(id: event.id).for_date_time_range(start_date, end_date + 2.days).count.must_equal 3 } }

  describe 'with multiple occurrences' do
    let(:second_start_date) { start_date + 2.weeks }
    let(:second_end_date) { second_start_date + 2.hours }
    let(:second_schedule) { IceCube::Schedule.new(second_start_date.to_time) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }
    let(:second_occurrence) { DummyOccurrence.new(dtstart: second_start_date, dtend: second_end_date, schedule: second_schedule) }
    let(:event) { DummyEvent.new(occurrences: [occurrence, second_occurrence]) }

    it { with_view { DummyEvent.where(id: event.id).count.must_equal 14 } }
    it { with_view { DummyEvent.where(id: event.id).for_date_time_range(second_start_date, second_end_date + 2.days).count.must_equal 3 } }
  end

  private

  def with_view(&block)
    DummyEvent.with_expanded_occurrences_view(&block)
  end
end
