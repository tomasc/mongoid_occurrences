require 'test_helper'

describe 'Query Expanded defined by range' do
  let(:occurrence) { DummyOccurrence.new(dtstart: start_date, dtend: end_date) }
  let(:event) { DummyEvent.new(occurrences: [occurrence]) }

  before { event.save! }

  describe 'single day' do
    let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
    let(:end_date) { start_date + 4.hours }

    describe 'with hours from to' do
      let(:all_day) { false }

      it { with_view { DummyEvent.all.length.must_equal 1 } }

      it 'keeps orignal hours' do
        with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date] }
        with_view { DummyEvent.pluck(:_dtend).must_equal [end_date] }
      end
    end

    describe 'all_day' do
      let(:all_day) { true }

      it { with_view { DummyEvent.all.length.must_equal 1 } }

      it 'resets hours to beginning & end of day' do
        with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date.beginning_of_day] }
        with_view { DummyEvent.pluck(:_dtend).map(&:to_i).must_equal [end_date.end_of_day.to_i] }
      end
    end
  end

  # describe 'spanning days' do
  #   let(:start_date) { DateTime.parse('20/08/2018 10:00 +0200') }
  #   let(:end_date) { DateTime.parse('24/08/2018 21:00 +0200') }
  #
  #   it { with_view { DummyEvent.all.length.must_equal 5 } }
  #   it { with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date].push(4.times.map{ |i| (start_date + (i+1).day).beginning_of_day }).flatten } }
  #
  #   describe 'all_day' do
  #     let(:all_day) { true }
  #
  #     it { with_view { DummyEvent.all.length.must_equal 5 } }
  #     it { with_view { DummyEvent.pluck(:_dtstart).must_equal 5.times.map{ |i| (start_date + i.day).beginning_of_day } } }
  #     it { with_view { DummyEvent.pluck(:_dtend).must_equal 5.times.map{ |i| (start_date + i.day).end_of_day } } }
  #   end
  # end

  private

  def with_view(&block)
    DummyEvent.with_expanded_occurrences_view(&block)
  end
end
