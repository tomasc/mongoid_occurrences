require 'test_helper'

describe MongoidOccurrences::Occurrence::HasDailyOccurrences do
  let(:start_date) { occurrence.dtstart }
  let(:end_date) { occurrence.dtend }

  describe 'spanning one day' do
    let(:occurrence) { build :occurrence, :today }

    it { _(occurrence.daily_occurrences.size).must_equal 1 }
    it { _(occurrence.daily_occurrences.map(&:dtstart)).must_equal [start_date] }
    it { _(occurrence.daily_occurrences.map(&:dtend)).must_equal [end_date] }
    it { _(occurrence.daily_occurrences.map(&:occurrence_id)).must_equal [occurrence.id] }

    describe 'all_day' do
      let(:occurrence) { build :occurrence, :today, :all_day }

      it { _(occurrence.daily_occurrences.map(&:dtstart)).must_equal [start_date.beginning_of_day] }
      it { _(occurrence.daily_occurrences.map(&:dtend)).must_equal [end_date.end_of_day] }
    end
  end

  describe 'spanning multiple days' do
    let(:occurrence) { build :occurrence, :today_until_tomorrow }

    it { _(occurrence.daily_occurrences.size).must_equal 2 }
    it { _(occurrence.daily_occurrences.map(&:dtstart)).must_equal [start_date, (start_date + 1.day).beginning_of_day] }
    it { _(occurrence.daily_occurrences.map(&:dtend)).must_equal [start_date.end_of_day, end_date] }

    describe 'all_day' do
      let(:occurrence) { build(:occurrence, :today_until_tomorrow, :all_day) }

      it { _(occurrence.daily_occurrences.map(&:dtstart)).must_equal [start_date.beginning_of_day, (start_date + 1.day).beginning_of_day] }
      it { _(occurrence.daily_occurrences.map(&:dtend)).must_equal [start_date.end_of_day, end_date.end_of_day] }
    end
  end

  describe 'from schedule' do
    let(:occurrence) { build :occurrence, :today, schedule: build(:schedule, :daily_for_a_week) }

    it { _(occurrence.daily_occurrences.size).must_equal 7 }
    it { _(occurrence.daily_occurrences.map(&:occurrence_id).uniq).must_equal [occurrence.id] }
    it { _(occurrence.daily_occurrences.map(&:dtstart)).must_equal [start_date, start_date + 1.day, start_date + 2.days, start_date + 3.days, start_date + 4.days, start_date + 5.days, start_date + 6.days] }
    it { _(occurrence.daily_occurrences.map(&:dtend)).must_equal [end_date, end_date + 1.day, end_date + 2.days, end_date + 3.days, end_date + 4.days, end_date + 5.days, end_date + 6.days] }
  end
end
