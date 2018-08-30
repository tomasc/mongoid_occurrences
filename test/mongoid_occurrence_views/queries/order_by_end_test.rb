require 'test_helper'

describe MongoidOccurrenceViews::Queries::OrderByEnd do
  let(:query_ascending) { subject.criteria(klass, :asc, dtend_field: :_dtend) }
  let(:query_descending) { subject.criteria(klass, :desc, dtend_field: :_dtend) }

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

    # it { with_occurrences_ordering_view { query_ascending.pluck(:_dtend).must_equal [today.dtend, tomorrow.dtend, next_week.dtend] } }
    # it { with_occurrences_ordering_view { query_descending.pluck(:_dtend).must_equal [next_week.dtend, tomorrow.dtend, today.dtend] } }
    it { with_expanded_occurrences_view { query_ascending.pluck(:_dtend).must_equal [last_week.dtend, yesterday.dtend, today.dtend, tomorrow.dtend, next_week.dtend] } }
    it { with_expanded_occurrences_view { query_descending.pluck(:_dtend).must_equal [next_week.dtend, tomorrow.dtend, today.dtend, yesterday.dtend, last_week.dtend] } }
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

    # it { with_occurrences_ordering_view { query_ascending.pluck(:_dtend).must_equal [today.dtend, tomorrow.dtend, next_week.dtend] } }
    # it { with_occurrences_ordering_view { query_descending.pluck(:_dtend).must_equal [next_week.dtend, tomorrow.dtend, today.dtend] } }
    it { with_expanded_occurrences_view { query_ascending.pluck(:_dtend).must_equal [last_week.dtend, yesterday.dtend, today.dtend, tomorrow.dtend, next_week.dtend] } }
    it { with_expanded_occurrences_view { query_descending.pluck(:_dtend).must_equal [next_week.dtend, tomorrow.dtend, today.dtend, yesterday.dtend, last_week.dtend] } }
  end

  private

  # def with_occurrences_ordering_view(&block)
  #   klass.with_occurrences_ordering_view(&block)
  # end

  def with_expanded_occurrences_view(&block)
    klass.with_expanded_occurrences_view(&block)
  end
end
