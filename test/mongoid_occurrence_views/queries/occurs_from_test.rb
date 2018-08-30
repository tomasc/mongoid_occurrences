require 'test_helper'

describe MongoidOccurrenceViews::Queries::OccursFrom do
  let(:today) { DateTime.now.beginning_of_day }
  let(:unexpanded_query) { subject.criteria(klass.criteria, query_date_time, dtstart_field: unexpanded_dtstart_field) }
  let(:unexpanded_query_for_next_year) { subject.criteria(klass.criteria, query_date_time + 1.year, dtstart_field: unexpanded_dtstart_field) }
  let(:expanded_query) { subject.criteria(klass.criteria, query_date_time, dtstart_field: :_dtstart) }
  let(:expanded_query_for_next_year) { subject.criteria(klass.criteria, query_date_time + 1.year, dtstart_field: :_dtstart) }

  describe 'Querying Events' do
    let(:klass) { Event }
    let(:unexpanded_dtstart_field) { :'occurrences.daily_occurrences.ds' }

    describe 'spanning one day' do
      before { create(:event, :today) }

      let(:query_date_time) { today }

      it { unexpanded_query.count.must_equal 1 }
      it { unexpanded_query_for_next_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { expanded_query.count.must_equal 1 } }
      it { with_expanded_occurrences_view { expanded_query_for_next_year.count.must_equal 0 } }
      # it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      # it { with_occurrences_ordering_view { query_for_next_year.count.must_equal 0 } }
    end

    describe 'spanning multiple days' do
      before { create(:event, :today_until_tomorrow) }

      let(:query_date_time) { today }

      it { unexpanded_query.count.must_equal 1 }
      it { unexpanded_query_for_next_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { expanded_query.count.must_equal 2 } }
      it { with_expanded_occurrences_view { expanded_query_for_next_year.count.must_equal 0 } }
      # it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      # it { with_occurrences_ordering_view { query_for_next_year.count.must_equal 0 } }
    end

    describe 'recurring' do
      before { create(:event, :recurring_daily_this_week) }

      let(:query_date_time) { today + 2.days }

      it { unexpanded_query.count.must_equal 1 }
      it { unexpanded_query_for_next_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { expanded_query.count.must_equal 5 } }
      it { with_expanded_occurrences_view { expanded_query_for_next_year.count.must_equal 0 } }
      # it { with_occurrences_ordering_view { query.count.must_equal 0 } }
      # it { with_occurrences_ordering_view { query_for_next_year.count.must_equal 0 } }
    end
  end

  describe 'Querying Parent with Embedded Events' do
    let(:klass) { EventParent }
    let(:unexpanded_dtstart_field) { :'embedded_events.occurrences.daily_occurrences.ds' }

    describe 'spanning one day' do
      before { create(:event_parent, :today) }

      let(:query_date_time) { today }

      it { unexpanded_query.count.must_equal 1 }
      it { unexpanded_query_for_next_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { expanded_query.count.must_equal 1 } }
      it { with_expanded_occurrences_view { expanded_query_for_next_year.count.must_equal 0 } }
      # it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      # it { with_occurrences_ordering_view { query_for_next_year.count.must_equal 0 } }
    end

    describe 'spanning multiple days' do
      before { create(:event_parent, :today_until_tomorrow) }

      let(:query_date_time) { today }

      it { unexpanded_query.count.must_equal 1 }
      it { unexpanded_query_for_next_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { expanded_query.count.must_equal 2 } }
      it { with_expanded_occurrences_view { expanded_query_for_next_year.count.must_equal 0 } }
      # it { with_occurrences_ordering_view { query.count.must_equal 1 } }
      # it { with_occurrences_ordering_view { query_for_next_year.count.must_equal 0 } }
    end

    describe 'recurring' do
      before { create(:event_parent, :recurring_daily_this_week) }

      let(:query_date_time) { today + 2.days }

      it { unexpanded_query.count.must_equal 1 }
      it { unexpanded_query_for_next_year.count.must_equal 0 }
      it { with_expanded_occurrences_view { expanded_query.count.must_equal 5 } }
      it { with_expanded_occurrences_view { expanded_query_for_next_year.count.must_equal 0 } }
      # it { with_occurrences_ordering_view { query.count.must_equal 0 } }
      # it { with_occurrences_ordering_view { query_for_next_year.count.must_equal 0 } }
    end
  end

  private

  # def with_occurrences_ordering_view(&block)
  #   klass.with_occurrences_ordering_view(&block)
  # end

  def with_expanded_occurrences_view(&block)
    klass.with_expanded_occurrences_view(&block)
  end
end
