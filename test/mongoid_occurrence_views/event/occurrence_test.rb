require 'test_helper'

describe MongoidOccurrenceViews::Event::Occurrence do
  let(:today) { DateTime.now.beginning_of_day }

  let(:occurrence) { build(:occurrence, :today) }

  it { occurrence.must_respond_to :dtstart }
  it { occurrence.must_respond_to :dtend }
  it { occurrence.must_respond_to :all_day }
  it { occurrence.must_respond_to :all_day? }
  it { occurrence.must_respond_to :schedule }

  it { occurrence.must_respond_to :event }
  it { occurrence.must_respond_to :daily_occurrences }

  describe 'all_day' do
    let(:occurrence) { build(:occurrence, :today) }

    describe 'when dtstart & dtend set to beginning & end of day' do
      before do
        occurrence.dtstart = today
        occurrence.dtend = today.end_of_day
      end

      it { occurrence.must_be :all_day? }
      it { occurrence.dtend.must_equal today.end_of_day }
    end

    describe 'when dtstart & dtend not set to beginning & end of day' do
      it { occurrence.wont_be :all_day? }
    end
  end

  describe '#adjust_dates_for_all_day on validate!' do
    let(:occurrence) { build(:occurrence, :today, :all_day) }

    before { occurrence.validate! }

    it { occurrence.dtstart.must_equal today.beginning_of_day }
    it { occurrence.dtend.must_equal today.end_of_day }
  end

  describe 'expansion' do
    before { occurrence.validate! }

    describe 'spanning one day' do
      let(:occurrence) { build(:occurrence, :today) }

      it { occurrence.daily_occurrences.to_a.size.must_equal 1 }
      it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [occurrence.dtstart] }
      it { occurrence.daily_occurrences.pluck(:dtend).must_equal [occurrence.dtend] }

      describe 'all_day' do
        let(:occurrence) { build(:occurrence, :today, :all_day) }

        it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [today.beginning_of_day] }
        it { occurrence.daily_occurrences.pluck(:dtend).must_equal [today.end_of_day] }
      end

      describe 'persistence' do
        it { occurrence.daily_occurrences.to_a.size.wont_equal 2 }
      end
    end

    describe 'spanning multiple days' do
      let(:occurrence) { build(:occurrence, :today_until_tomorrow) }
      let(:start_date) { occurrence.dtstart }
      let(:end_date) { occurrence.dtend }

      it { occurrence.daily_occurrences.to_a.size.must_equal 2 }
      it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [start_date, (start_date + 1.day).beginning_of_day] }
      it { occurrence.daily_occurrences.pluck(:dtend).must_equal [start_date.end_of_day, end_date] }

      describe 'all_day' do
        let(:occurrence) { build(:occurrence, :today_until_tomorrow, :all_day) }

        it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [start_date.beginning_of_day, (start_date + 1.day).beginning_of_day] }
        it { occurrence.daily_occurrences.pluck(:dtend).must_equal [start_date.end_of_day, end_date.end_of_day] }
      end
    end

    describe 'recurring' do
      let(:occurrence) { build(:occurrence, :recurring_daily_this_week) }
      let(:start_date) { occurrence.dtstart }
      let(:end_date) { occurrence.dtend }

      it { occurrence.daily_occurrences.to_a.size.must_equal 7 }
      it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [start_date.utc, start_date + 1.day, start_date + 2.days, start_date + 3.days, start_date + 4.days, start_date + 5.days, start_date + 6.days] }
      it { occurrence.daily_occurrences.pluck(:dtend).must_equal [end_date, end_date + 1.day, end_date + 2.days, end_date + 3.days, end_date + 4.days, end_date + 5.days, end_date + 6.days] }
    end
  end
end
