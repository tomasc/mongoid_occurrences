require 'test_helper'

describe 'Query Expanded defined by range' do
  let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
  let(:all_day) { false }
  let(:occurrence) { DummyOccurrence.new(dtstart: start_date, dtend: end_date, all_day: all_day) }
  let(:event) { DummyEvent.new(occurrences: [occurrence]) }

  before { event.save! }

  describe 'spanning single day' do
    let(:end_date) { start_date + 4.hours }

    describe 'with hours from to' do
      it { with_view { DummyEvent.where(id: event.id).for_date_time_range(start_date, end_date).count.must_equal 1 } }

      it 'keeps original hours' do
        with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date] }
        with_view { DummyEvent.pluck(:_dtend).must_equal [end_date] }
      end
    end

    describe 'all_day' do
      let(:all_day) { true }

      it 'resets hours to beginning & end of day' do
        with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date.beginning_of_day.utc] }
        with_view { DummyEvent.pluck(:_dtend).map(&:to_i).must_equal [end_date.end_of_day.to_i] }
      end

      it 'resets hours to beginning & end of day' do
        with_view { DummyEvent.pluck(:_dtstart).must_equal [start_date.beginning_of_day.utc] }
        with_view { DummyEvent.pluck(:_dtend).map(&:to_i).must_equal [end_date.end_of_day.to_i] }
      end
    end
  end

  describe 'spanning days' do
    let(:end_date) { start_date + 4.days }

    it { with_view { DummyEvent.where(id: event.id).for_date_time_range(start_date, end_date).count.must_equal 5 } }
  end

  private

  def with_view(&block)
    DummyEvent.with_expanded_occurrences_view(&block)
  end
end
