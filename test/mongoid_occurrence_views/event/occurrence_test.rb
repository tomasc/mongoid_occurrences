require 'test_helper'

describe MongoidOccurrenceViews::Event::Occurrence do
  let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
  let(:end_date) { DateTime.parse('20/08/2018 21:00 +0200') }
  let(:all_day) { false }
  let(:schedule) { nil }

  let(:occurrence) { Occurrence.new(dtstart: start_date, dtend: end_date, all_day: all_day, schedule: schedule) }

  it { occurrence.must_respond_to :dtstart }
  it { occurrence.must_respond_to :dtend }
  it { occurrence.must_respond_to :all_day }
  it { occurrence.must_respond_to :all_day? }
  it { occurrence.must_respond_to :schedule }

  it { occurrence.must_respond_to :event }
  it { occurrence.must_respond_to :daily_occurrences }

  describe 'all_day' do
    describe 'when dtstart & dtend set to beginning & end of day' do
      let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200').beginning_of_day }
      let(:end_date) { DateTime.parse('20/08/2018 21:00 +0200').end_of_day }

      it { occurrence.must_be :all_day? }
      it { occurrence.dtend.must_equal end_date }
    end

    describe 'when dtstart & dtend not set to beginning & end of day' do
      let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
      let(:end_date) { DateTime.parse('20/08/2018 21:00 +0200') }

      it { occurrence.wont_be :all_day? }
    end
  end

  describe '#adjust_dates_for_all_day on validate!' do
    let(:all_day) { true }

    before { occurrence.validate! }

    it { occurrence.dtstart.must_equal start_date.beginning_of_day }
    it { occurrence.dtend.must_equal end_date.end_of_day }
  end

  describe 'expansion' do
    describe 'with schedule' do
      let(:schedule) { IceCube::Schedule.new(start_date.to_time) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }

      before { occurrence.validate! }

      it { occurrence.daily_occurrences.to_a.size.must_equal 7 }
      it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [start_date, start_date + 1.day, start_date + 2.days, start_date + 3.days, start_date + 4.days, start_date + 5.days, start_date + 6.days] }
      it { occurrence.daily_occurrences.pluck(:dtend).must_equal [end_date, end_date + 1.day, end_date + 2.days, end_date + 3.days, end_date + 4.days, end_date + 5.days, end_date + 6.days] }
    end

    describe 'with date_time range' do
      before { occurrence.validate! }

      describe 'spanning one day' do
        it { occurrence.daily_occurrences.to_a.size.must_equal 1 }
        it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [start_date] }
        it { occurrence.daily_occurrences.pluck(:dtend).must_equal [end_date] }

        describe 'all_day' do
          let(:all_day) { true }

          it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [start_date.beginning_of_day] }
          it { occurrence.daily_occurrences.pluck(:dtend).must_equal [end_date.end_of_day] }
        end
      end

      describe 'spanning multiple days' do
        let(:end_date) { DateTime.parse('22/08/2018 21:00 +0200') }

        it { occurrence.daily_occurrences.to_a.size.must_equal 3 }
        it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [start_date, (start_date + 1.day).beginning_of_day, (start_date + 2.days).beginning_of_day] }
        it { occurrence.daily_occurrences.pluck(:dtend).must_equal [start_date.end_of_day, (start_date + 1.day).end_of_day, end_date] }

        describe 'all_day' do
          let(:end_date) { DateTime.parse('22/08/2018 21:00 +0200') }
          let(:all_day) { true }

          it { occurrence.daily_occurrences.pluck(:dtstart).must_equal [start_date.beginning_of_day, (start_date + 1.day).beginning_of_day, (start_date + 2.days).beginning_of_day] }
          it { occurrence.daily_occurrences.pluck(:dtend).must_equal [start_date.end_of_day, (start_date + 1.day).end_of_day, end_date.end_of_day] }
        end
      end
    end
  end
end
