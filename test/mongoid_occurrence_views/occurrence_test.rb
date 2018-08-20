require "test_helper"

describe MongoidOccurrenceViews::Occurrence do
  let(:start_date) { DateTime.parse '20/08/2018 09:00' }
  let(:end_date) { DateTime.parse '20/08/2018 21:00' }
  let(:all_day) { false }
  let(:schedule) { nil }

  let(:occurrence) { DummyOccurrence.new(dtstart: start_date, dtend: end_date, all_day: all_day, schedule: schedule) }

  describe 'fields' do
    it { occurrence.must_respond_to :dtstart }
    it { occurrence.must_respond_to :dtend }
    it { occurrence.must_respond_to :all_day }
    it { occurrence.must_respond_to :schedule }
  end

  describe 'relations' do
    it { occurrence.must_respond_to :daily_occurrences }
  end

  describe 'expanding schedule' do
    let(:schedule) { IceCube::Schedule.new(start_date) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }

    before { occurrence.validate! }

    it { occurrence.daily_occurrences.to_a.count.must_equal 7 }
    it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [] } # TODO: specify expected result
    it { occurrence.daily_occurrences.pluck(:dtend).must_equal [] } # TODO: specify expected result
    it { occurrence.daily_occurrences.pluck(:all_day).uniq.must_equal [false] }
  end

  describe 'expanding datetime range' do

  end
end
