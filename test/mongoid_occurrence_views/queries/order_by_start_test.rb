require 'test_helper'

describe MongoidOccurrenceViews::Queries::OrderByStart do
  let(:query_ascending) { subject.criteria(klass.criteria, :asc, dtstart_field: :_dtstart) }
  let(:query_descending) { subject.criteria(klass.criteria, :desc, dtstart_field: :_dtstart) }

  let(:yesterday) { build :occurrence, :yesterday }
  let(:today) { build :occurrence, :today }
  let(:tomorrow) { build :occurrence, :tomorrow }
  let(:last_week) { build :occurrence, :last_week }
  let(:next_week) { build :occurrence, :next_week }

  describe 'Ordering Events' do
    let(:klass) { Event }

    before do
      create :event, occurrences: [yesterday, last_week, tomorrow]
      create :event, occurrences: [today]
      create :event, occurrences: [next_week]
    end

    # it { with_occurrences_ordering_view { query_ascending.pluck(:_dtstart).must_equal [last_week.dtstart, today.dtstart, next_week.dtstart] } }
    # it { with_occurrences_ordering_view { query_descending.pluck(:_dtstart).must_equal [next_week.dtstart, today.dtstart, last_week.dtstart] } }
    it { with_expanded_occurrences_view { query_ascending.pluck(:_dtstart).must_equal [last_week.dtstart, yesterday.dtstart, today.dtstart, tomorrow.dtstart, next_week.dtstart] } }
    it { with_expanded_occurrences_view { query_descending.pluck(:_dtstart).must_equal [next_week.dtstart, tomorrow.dtstart, today.dtstart, yesterday.dtstart, last_week.dtstart] } }
  end

  describe 'Ordering Parents with Embedded Events' do
    let(:klass) { EventParent }

    let(:event_yesterday) { build :embedded_event, occurrences: [yesterday] }
    let(:event_today) { build :embedded_event, occurrences: [today] }
    let(:event_tomorrow) { build :embedded_event, occurrences: [tomorrow] }
    let(:event_last_week) { build :embedded_event, occurrences: [last_week] }
    let(:event_next_week) { build :embedded_event, occurrences: [next_week] }

    before do
      create :event_parent, embedded_events: [event_yesterday, event_last_week, event_tomorrow]
      create :event_parent, embedded_events: [event_today]
      create :event_parent, embedded_events: [event_next_week]
    end

    # it { with_occurrences_ordering_view { query_ascending.pluck(:_dtstart).must_equal [last_week.dtstart, today.dtstart, next_week.dtstart] } }
    # it { with_occurrences_ordering_view { query_descending.pluck(:_dtstart).must_equal [next_week.dtstart, today.dtstart, last_week.dtstart] } }
    it { with_expanded_occurrences_view { query_ascending.pluck(:_dtstart).must_equal [last_week.dtstart, yesterday.dtstart, today.dtstart, tomorrow.dtstart, next_week.dtstart] } }
    it { with_expanded_occurrences_view { query_descending.pluck(:_dtstart).must_equal [next_week.dtstart, tomorrow.dtstart, today.dtstart, yesterday.dtstart, last_week.dtstart] } }
  end

  private

  # def with_occurrences_ordering_view(&block)
  #   klass.with_occurrences_ordering_view(&block)
  # end

  def with_expanded_occurrences_view(&block)
    klass.with_expanded_occurrences_view(&block)
  end
end
