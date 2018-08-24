# TODO: add this test

# require 'test_helper'
#
# describe 'Queries for events' do
#   let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
#   let(:end_date) { start_date + 4.days }
#   let(:all_day) { false }
#   let(:occurrence) { Occurrence.new(dtstart: start_date, dtend: end_date, all_day: all_day) }
#   let(:event) { Event.new(occurrences: [occurrence]) }
#
#   before { event.save! }
#
#   it { within_expanded_occurrences { Event.where(id: event.id).date_time_range(start_date, end_date).count.must_equal 5 } }
#
#   private
#
#   def within_expanded_occurrences(&block)
#     Event.within_occurrences(&block)
#   end
# end

# describe 'scopes' do
#   let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
#   let(:end_date) { start_date + 2.hours }
#   let(:occurrence) { ::Occurrence.new(dtstart: start_date, dtend: end_date, all_day: false) }
#   let(:event) { ::Event.new(occurrences: [occurrence])  }
#
#   before { event.save! }
#
#   # Question: Should we just test like this? ...
#   it { event.class.must_respond_to :for_date_time_range }
#   it { event.class.must_respond_to :for_date_time }
#   it { event.class.must_respond_to :from_date_time }
#   it { event.class.must_respond_to :to_date_time }
#
#   # ... And then move these to individual tests of each query object?
#   describe '.date_time_range' do
#     it { ::Event.date_time_range(start_date, end_date).to_a.must_include event }
#     it { ::Event.date_time_range(start_date + 1.week, end_date + 1.week).to_a.wont_include event }
#
#     it { within_expanded_occurrences { ::Event.date_time_range(start_date, end_date).to_a.must_include event } }
#     it { within_expanded_occurrences { ::Event.date_time_range(start_date + 1.week, end_date + 1.week).to_a.wont_include event } }
#   end
#
#   describe '.date_time' do
#     it { ::Event.date_time(start_date).to_a.must_include event }
#     it { ::Event.date_time(end_date + 1.day).to_a.wont_include event }
#
#     it { within_expanded_occurrences { ::Event.date_time(start_date).to_a.must_include event } }
#     it { within_expanded_occurrences { ::Event.date_time(end_date + 1.day).to_a.wont_include event } }
#   end
#
#   describe '.from_date_time' do
#     it { ::Event.from_date_time(start_date).to_a.must_include event }
#     it { ::Event.from_date_time(end_date).to_a.wont_include event }
#
#     it { within_expanded_occurrences { ::Event.from_date_time(start_date).to_a.must_include event } }
#     it { within_expanded_occurrences { ::Event.from_date_time(end_date).to_a.wont_include event } }
#   end
#
#   describe '.to_date_time' do
#     it { ::Event.to_date_time(end_date).to_a.must_include event }
#     it { ::Event.to_date_time(start_date).to_a.wont_include event }
#
#     it { within_expanded_occurrences { ::Event.to_date_time(end_date).to_a.must_include event } }
#     it { within_expanded_occurrences { ::Event.to_date_time(start_date).to_a.wont_include event } }
#   end
# end

# describe "Embedding of Event" do
#   let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
#   let(:end_date) { start_date + 2.hours }
#   let(:occurrence) { Occurrence.new(dtstart: start_date, dtend: end_date, all_day: false) }
#   let(:event) { Event.new(occurrences: [occurrence])  }
#   let(:owner) { EventParent.new(events: [event]) }
#
#   before { owner.save! }
#
#   describe 'expanded' do
#     it { owner.class.date_time_range(start_date, end_date).count.must_equal 0 }
#     it { owner.class.date_time_range(start_date, end_date).to_a.wont_include owner }
#     it { within_expanded_occurrences { owner.class.date_time_range(start_date, end_date).count.must_equal 1 } }
#     it { within_expanded_occurrences { owner.class.date_time_range(start_date, end_date).to_a.must_include owner } }
#   end
#
#   private
#
#   def within_expanded_occurrences(&block)
#     EventParent.within_expanded_occurrences(&block)
#   end
# end
