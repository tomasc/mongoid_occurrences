# require 'test_helper'
#
# describe 'Query Expanded defined by recurring schedule' do
#   let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
#   let(:end_date) { start_date + 2.hours }
#   let(:schedule) { IceCube::Schedule.new(start_date.to_time) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }
#   let(:occurrence) { Occurrence.new(dtstart: start_date, dtend: end_date, schedule: schedule) }
#   let(:event) { Event.new(occurrences: [occurrence]) }
#
#   before { event.save! }
#
#   it { within_expanded_occurrences { Event.where(id: event.id).count.must_equal 7 } }
#   it { within_expanded_occurrences { Event.where(id: event.id).date_time_range(start_date, end_date + 2.days).count.must_equal 3 } }
#
#   describe 'with multiple occurrences' do
#     let(:second_start_date) { start_date + 2.weeks }
#     let(:second_end_date) { second_start_date + 2.hours }
#     let(:second_schedule) { IceCube::Schedule.new(second_start_date.to_time) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }
#     let(:second_occurrence) { Occurrence.new(dtstart: second_start_date, dtend: second_end_date, schedule: second_schedule) }
#     let(:event) { Event.new(occurrences: [occurrence, second_occurrence]) }
#
#     it { within_expanded_occurrences { Event.where(id: event.id).count.must_equal 14 } }
#     it { within_expanded_occurrences { Event.where(id: event.id).date_time_range(second_start_date, second_end_date + 2.days).count.must_equal 3 } }
#   end
#
#   private
#
#   def within_expanded_occurrences(&block)
#     Event.within_expanded_occurrences(&block)
#   end
# end
