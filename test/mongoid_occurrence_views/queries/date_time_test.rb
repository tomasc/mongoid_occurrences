require 'test_helper'

describe 'Querying Events' do
  let(:query) { MongoidOccurrenceViews::Queries::DateTime.criteria(Event, query_date_time) }
  let(:wrong_query) { MongoidOccurrenceViews::Queries::DateTime.criteria(Event, query_date_time - 1.year) }

  before { event.save! }

  describe 'spanning one day' do
    let(:event) { build(:event, :today) }
    let(:query_date_time) { DateTime.now.beginning_of_day + 5.hours }

    it { query.count.must_equal 1 }
    it { wrong_query.count.must_equal 0 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    it { within_expanded_occurrences { wrong_query.count.must_equal 0 } }
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  describe 'spanning multiple days' do
    let(:event) { build(:event, :today_until_tomorrow) }
    let(:query_date_time) { DateTime.now.beginning_of_day + 1.day }

    it { query.count.must_equal 1 }
    it { wrong_query.count.must_equal 0 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    it { within_expanded_occurrences { wrong_query.count.must_equal 0 } }
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  describe 'recurring' do
    let(:event) { build(:event, :recurring_daily_this_week) }
    let(:query_date_time) { DateTime.now.beginning_of_day + 2.days }

    it { query.count.must_equal 1 }
    it { wrong_query.count.must_equal 0 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    it { within_expanded_occurrences { wrong_query.count.must_equal 0 } }
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
  let(:query) { MongoidOccurrenceViews::Queries::DateTime.criteria(EventParent, query_date_time) }
  let(:wrong_query) { MongoidOccurrenceViews::Queries::DateTime.criteria(Event, query_date_time - 1.year) }

  before { event_parent.save! }

  describe 'spanning one day' do
    let(:event_parent) { build(:event_parent, :today) }
    let(:query_date_time) { DateTime.now.beginning_of_day + 5.hours }

    it { query.count.must_equal 0 }
    it { wrong_query.count.must_equal 0 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    it { within_expanded_occurrences { wrong_query.count.must_equal 0 } }
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  describe 'spanning multiple days' do
    let(:event_parent) { build(:event_parent, :today_until_tomorrow) }
    let(:query_date_time) { DateTime.now.beginning_of_day + 1.day }

    it { query.count.must_equal 0 }
    it { wrong_query.count.must_equal 0 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    it { within_expanded_occurrences { wrong_query.count.must_equal 0 } }
    # it { within_occurrences { query.count.must_equal 1 } }
  end

  describe 'recurring' do
    let(:event_parent) { build(:event_parent, :recurring_daily_this_week) }
    let(:query_date_time) { DateTime.now.beginning_of_day + 3.days }

    it { query.count.must_equal 0 }
    it { wrong_query.count.must_equal 0 }
    it { within_expanded_occurrences { query.count.must_equal 1 } }
    it { within_expanded_occurrences { wrong_query.count.must_equal 0 } }
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
