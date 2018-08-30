require 'test_helper'

describe MongoidOccurrenceViews::Queries::OccursUntil do
  let(:today) { DateTime.now.beginning_of_day }
  let(:query) { subject.criteria(klass, query_date_time) }
  let(:query_with_no_match) { subject.criteria(klass, query_date_time - 1.year) }

  describe 'Querying Events' do
    let(:klass) { Event }

    describe 'spanning one day' do
      before { create(:event, :today) }

      let(:query_date_time) { today + 1.day }

      it { query.count.must_equal 1 }
      it { query_with_no_match.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 1 } }
      it { with_expanded_occurrences_view { query_with_no_match.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      it { with_occurrences_ordering_view { query_with_no_match.count.must_equal 0 } }
    end

    describe 'spanning multiple days' do
      before { create(:event, :today_until_tomorrow) }

      let(:query_date_time) { today + 1.day }

      it { query.count.must_equal 1 }
      it { query_with_no_match.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 2 } }
      it { with_expanded_occurrences_view { query_with_no_match.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      it { with_occurrences_ordering_view { query_with_no_match.count.must_equal 0 } }
    end

    describe 'recurring' do
      before { create(:event, :recurring_daily_this_week) }

      let(:query_date_time) { today + 2.days }

      it { query.count.must_equal 1 }
      it { query_with_no_match.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 2 } }
      it { with_expanded_occurrences_view { query_with_no_match.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query_with_no_match.count.must_equal 0 } }
    end
  end

  describe 'Querying Parent with Embedded Events' do
    let(:klass) { EventParent }

    describe 'spanning one day' do
      before { create(:event_parent, :today) }

      let(:query_date_time) { today + 1.day }

      it { query.count.must_equal 1 }
      it { query_with_no_match.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 1 } }
      it { with_expanded_occurrences_view { query_with_no_match.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
    end

    describe 'spanning multiple days' do
      before { create(:event_parent, :today_until_tomorrow) }

      let(:query_date_time) { today + 1.day }

      it { query.count.must_equal 1 }
      it { query_with_no_match.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 2 } }
      it { with_expanded_occurrences_view { query_with_no_match.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 1 } }
    end

    describe 'recurring' do
      before { create(:event_parent, :recurring_daily_this_week) }

      let(:query_date_time) { today + 3.days }

      it { query.count.must_equal 1 }
      it { query_with_no_match.count.must_equal 0 }
      it { with_expanded_occurrences_view { query.count.must_equal 3 } }
      it { with_expanded_occurrences_view { query_with_no_match.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query.count.must_equal 0 } }
      it { with_occurrences_ordering_view { query_with_no_match.count.must_equal 0 } }
    end
  end

  private

  def with_occurrences_ordering_view(&block)
    klass.with_occurrences_ordering_view(&block)
  end

  def with_expanded_occurrences_view(&block)
    klass.with_expanded_occurrences_view(&block)
  end
end
