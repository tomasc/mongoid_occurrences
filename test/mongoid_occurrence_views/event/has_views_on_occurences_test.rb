require 'test_helper'

describe MongoidOccurrenceViews::Event::HasViewsOnOccurrences do
  describe 'included in Event' do
    let(:klass) { Event }

    it { klass.occurrences_ordering_view_name.must_equal 'events__occurrences_ordering_view' }
    it { klass.expanded_occurrences_view_name.must_equal 'events__expanded_occurrences_view' }

    describe 'views' do
      let(:collection_names) { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten }

      it { collection_names.must_include klass.occurrences_ordering_view_name }
      it { collection_names.must_include klass.expanded_occurrences_view_name }
    end

    describe 'querying' do
      before { event.save! }

      describe 'spanning one day' do
        let(:event) { build(:event, :today) }

        it { klass.all.count.must_equal 1 }
        it { with_expanded_occurrences_view { klass.all.count.must_equal 1 } }
        it { with_occurrences_ordering_view { klass.all.count.must_equal 1 } }
      end

      describe 'spanning multiple days' do
        let(:event) { build(:event, :today_until_tomorrow) }

        it { klass.all.count.must_equal 1 }
        it { with_expanded_occurrences_view { klass.all.count.must_equal 2 } }
        it { with_occurrences_ordering_view { klass.all.count.must_equal 1 } }
      end

      describe 'recurring' do
        let(:event) { build(:event, :recurring_daily_this_week) }

        it { klass.all.count.must_equal 1 }
        it { with_occurrences_ordering_view { klass.all.count.must_equal 1 } }
        it { with_expanded_occurrences_view { klass.all.count.must_equal 7 } }
      end
    end
  end

  describe 'included in EventParent' do
    let(:klass) { EventParent }

    it { klass.occurrences_ordering_view_name.must_equal 'event_parents__occurrences_ordering_view' }
    it { klass.expanded_occurrences_view_name.must_equal 'event_parents__expanded_occurrences_view' }

    describe 'views' do
      let(:collection_names) { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten }

      it { collection_names.must_include klass.occurrences_ordering_view_name }
      it { collection_names.must_include klass.expanded_occurrences_view_name }
    end

    describe 'querying' do
      before { event_parent.save! }

      describe 'spanning one day' do
        let(:event_parent) { build(:event_parent, :today) }

        it { klass.all.count.must_equal 1 }
        it { with_expanded_occurrences_view { klass.all.count.must_equal 1 } }
        it { with_occurrences_ordering_view { klass.all.count.must_equal 1 } }
      end

      describe 'spanning multiple days' do
        let(:event_parent) { build(:event_parent, :today_until_tomorrow) }

        it { klass.all.count.must_equal 1 }
        it { with_expanded_occurrences_view { klass.all.count.must_equal 2 } }
        it { with_occurrences_ordering_view { klass.all.count.must_equal 1 } }
      end

      describe 'recurring' do
        let(:event_parent) { build(:event_parent, :recurring_daily_this_week) }

        it { klass.all.count.must_equal 1 }
        it { with_expanded_occurrences_view { klass.all.count.must_equal 7 } }
        it { with_occurrences_ordering_view { klass.all.count.must_equal 1 } }
      end
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
