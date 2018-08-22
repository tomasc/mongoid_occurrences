require 'test_helper'

describe 'Queries for Expanded events' do
  let(:all_day) { false }
  let(:schedule) { nil }
  let(:occurrence) { DummyOccurrence.new(dtstart: start_date, dtend: end_date, all_day: all_day, schedule: schedule) }
  let(:event) { DummyEvent.new(occurrences: [occurrence]) }

  before { event.save! }

  describe 'with datetime range' do
    describe 'single day' do
      let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
      let(:end_date) { DateTime.parse('20/08/2018 12:00 +0200') }

      it { with_view { DummyEvent.all.length.must_equal 1 } }
      it { with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date] } }
      it { with_view { DummyEvent.pluck(:_dtend).must_equal [end_date] } }

      describe 'all_day' do
        let(:all_day) { true }

        it { with_view { DummyEvent.all.length.must_equal 1 } }
        it { with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date.beginning_of_day] } }
        it { with_view { DummyEvent.pluck(:_dtend).map(&:to_i).must_equal [end_date.end_of_day.to_i] } }
      end
    end

    describe 'spanning days' do
      let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
      let(:end_date) { DateTime.parse('24/08/2018 21:00 +0200') }

      it { with_view { DummyEvent.all.length.must_equal 5 } }
      it { with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date].push(4.times.map{ |i| (start_date + (i+1).day).beginning_of_day }).flatten } }
    end
  end

  describe 'with schedule' do
    let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
    let(:end_date) { DateTime.parse('20/08/2018 12:00 +0200') }
    let(:schedule) { IceCube::Schedule.new(start_date.to_time) { |s| s.add_recurrence_rule IceCube::Rule.daily(1).count(7) } }

    it { with_view { DummyEvent.all.length.must_equal 7 } }
    it { with_view { DummyEvent.pluck(:_dtstart).must_equal 7.times.map{ |i| start_date + i.day } } }
  end

  private

  def with_view(&block)
    DummyEvent.with_expanded_occurrences_view(&block)
  end
end
