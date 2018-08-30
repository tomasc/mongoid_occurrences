require 'test_helper'

describe MongoidOccurrenceViews::Event::HasOccurrenceScopes do
  describe 'included in Event' do
    let(:klass) { Event }

    describe 'scopes' do
      it { klass.must_respond_to :occurs_between }
      it { klass.must_respond_to :occurs_from }
      it { klass.must_respond_to :occurs_on }
      it { klass.must_respond_to :occurs_until }
      it { klass.must_respond_to :order_by_start }
      it { klass.must_respond_to :order_by_end }
    end

    describe 'query fields' do
      it { klass.dtstart_query_field.must_equal :'occurrences.daily_occurrences.ds' }
      it { klass.dtend_query_field.must_equal :'occurrences.daily_occurrences.de' }
      it { with_expanded_occurrences_view { klass.dtstart_query_field.must_equal :_dtstart } }
      it { with_expanded_occurrences_view { klass.dtend_query_field.must_equal :_dtend } }
    end
  end

  describe 'included in EventParent' do
    let(:klass) { EventParent }

    describe 'scopes' do
      it { klass.must_respond_to :occurs_between }
      it { klass.must_respond_to :occurs_from }
      it { klass.must_respond_to :occurs_on }
      it { klass.must_respond_to :occurs_until }
      it { klass.must_respond_to :order_by_start }
      it { klass.must_respond_to :order_by_end }
    end

    describe 'query fields' do
      it { klass.dtstart_query_field.must_equal :'embedded_events.occurrences.daily_occurrences.ds' }
      it { klass.dtend_query_field.must_equal :'embedded_events.occurrences.daily_occurrences.de' }
      it { with_expanded_occurrences_view { klass.dtstart_query_field.must_equal :_dtstart } }
      it { with_expanded_occurrences_view { klass.dtend_query_field.must_equal :_dtend } }
    end
  end

  private

  def with_expanded_occurrences_view(&block)
    klass.with_expanded_occurrences_view(&block)
  end
end
