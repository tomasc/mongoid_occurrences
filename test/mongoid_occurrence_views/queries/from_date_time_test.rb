require 'test_helper'

describe MongoidOccurrenceViews::Queries::FromDateTime do
  let(:today) { DateTime.now.beginning_of_day }
  let(:query) { subject.criteria(klass, query_date_time) }
  let(:query_with_no_match) { subject.criteria(klass, query_date_time + 1.year) }

  describe 'Querying Events' do
    let(:klass) { Event }

    before { event.save! }

    describe 'spanning one day' do
      let(:event) { build(:event, :today) }
      let(:query_date_time) { today }

      it { query.count.must_equal 1 }
      it { query_with_no_match.count.must_equal 0 }

      it { within_expanded_occurrences { query.count.must_equal 1 } }
      it { within_expanded_occurrences { query_with_no_match.count.must_equal 0 } }
      # it { within_occurrences { query.count.must_equal 1 } }
    end

    describe 'spanning multiple days' do
      let(:event) { build(:event, :today_until_tomorrow) }
      let(:query_date_time) { today + 1.day }

      it { query.count.must_equal 1 }
      it { query_with_no_match.count.must_equal 0 }

      it { within_expanded_occurrences { query.count.must_equal 2 } }
      it { within_expanded_occurrences { query_with_no_match.count.must_equal 0 } }
      # it { within_occurrences { query.count.must_equal 1 } }
    end

    describe 'recurring' do
      let(:event) { build(:event, :recurring_daily_this_week) }
      let(:query_date_time) { today + 2.days }

      it { query.count.must_equal 1 }
      it { query_with_no_match.count.must_equal 0 }

      it { within_expanded_occurrences { query.count.must_equal 5 } }
      it { within_expanded_occurrences { query_with_no_match.count.must_equal 0 } }
      # it { within_occurrences { query.count.must_equal 1 } }
    end

    private

    def within_occurrences(&block)
      Event.within_occurrences(&block)
    end

    def within_expanded_occurrences(&block)
      Event.within_expanded_occurrences(&block)
    end
  end

  describe 'Querying Parent with Embedded Events' do
    let(:klass) { EventParent }

    before { event_parent.save! }

    describe 'spanning one day' do
      let(:event_parent) { build(:event_parent, :today) }
      let(:query_date_time) { today }

      it { query.count.must_equal 0 }
      it { query_with_no_match.count.must_equal 0 }

      it { within_expanded_occurrences { query.count.must_equal 1 } }
      it { within_expanded_occurrences { query_with_no_match.count.must_equal 0 } }
      # it { within_occurrences { query.count.must_equal 1 } }
    end

    describe 'spanning multiple days' do
      let(:event_parent) { build(:event_parent, :today_until_tomorrow) }
      let(:query_date_time) { today + 1.day }

      it { query.count.must_equal 0 }
      it { query_with_no_match.count.must_equal 0 }

      it { within_expanded_occurrences { query.count.must_equal 2 } }
      it { within_expanded_occurrences { query_with_no_match.count.must_equal 0 } }
      # it { within_occurrences { query.count.must_equal 1 } }
    end

    describe 'recurring' do
      let(:event_parent) { build(:event_parent, :recurring_daily_this_week) }
      let(:query_date_time) { today + 3.days }

      it { query.count.must_equal 0 }
      it { query_with_no_match.count.must_equal 0 }

      it { within_expanded_occurrences { query.count.must_equal 4 } }
      it { within_expanded_occurrences { query_with_no_match.count.must_equal 0 } }
      # it { within_occurrences { query.count.must_equal 1 } }
    end

    private

    def within_occurrences(&block)
      EventParent.within_occurrences(&block)
    end

    def within_expanded_occurrences(&block)
      EventParent.within_expanded_occurrences(&block)
    end
  end
end
