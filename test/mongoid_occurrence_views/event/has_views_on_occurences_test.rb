require "test_helper"

describe MongoidOccurrenceViews::Event::HasViewsOnOccurrences do
  describe 'included in Event' do
    let(:klass) { Event }

    it { klass.occurrences_view_name.must_equal 'events__occurrences_view' }
    it { klass.expanded_occurrences_view_name.must_equal 'events__expanded_occurrences_view' }

    describe 'views' do
      let(:collection_names) { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten }

      it { collection_names.must_include klass.occurrences_view_name }
      it { collection_names.must_include klass.expanded_occurrences_view_name }
    end

    describe 'within (expanded) occurences' do
      before { event.save! }

      describe 'spanning one day' do
        let(:event) { build(:event, :today) }

        it { klass.all.count.must_equal 1 }
        it { within_expanded_occurrences { klass.all.count.must_equal 1 } }
        # it { within_occurrences { query.count.must_equal 1 } }
      end

      describe 'spanning multiple days' do
        let(:event) { build(:event, :today_until_tomorrow) }

        it { klass.all.count.must_equal 1 }
        it { within_expanded_occurrences { klass.all.count.must_equal 2 } }
        # it { within_occurrences { query.count.must_equal 1 } }
      end

      describe 'recurring' do
        let(:event) { build(:event, :recurring_daily_this_week) }

        it { klass.all.count.must_equal 1 }
        it { within_expanded_occurrences { klass.all.count.must_equal 7 } }
        # it { within_occurrences { query.count.must_equal 1 } }
      end
    end

    private

    def within_occurrences(&block)
      Event.within_occurrences(&block)
    end

    def within_expanded_occurrences(&block)
      Event.within_expanded_occurrences(&block)
    end
  end

  describe 'included in EventParent' do
    let(:klass) { EventParent }

    it { klass.occurrences_view_name.must_equal 'event_parents__occurrences_view' }
    it { klass.expanded_occurrences_view_name.must_equal 'event_parents__expanded_occurrences_view' }

    describe 'views' do
      let(:collection_names) { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten }

      it { collection_names.must_include klass.occurrences_view_name }
      it { collection_names.must_include klass.expanded_occurrences_view_name }
    end

    describe 'within (expanded) occurrences' do
      before { event_parent.save! }

      describe 'spanning one day' do
        let(:event_parent) { build(:event_parent, :today) }

        it { klass.all.count.must_equal 1 }
        it { within_expanded_occurrences { klass.all.count.must_equal 1 } }
        # it { within_occurrences { query.count.must_equal 1 } }
      end

      describe 'spanning multiple days' do
        let(:event_parent) { build(:event_parent, :today_until_tomorrow) }

        it { klass.all.count.must_equal 1 }
        it { within_expanded_occurrences { klass.all.count.must_equal 2 } }
        # it { within_occurrences { query.count.must_equal 1 } }
      end

      describe 'recurring' do
        let(:event_parent) { build(:event_parent, :recurring_daily_this_week) }

        it { klass.all.count.must_equal 1 }
        it { within_expanded_occurrences { klass.all.count.must_equal 7 } }
        # it { within_occurrences { query.count.must_equal 1 } }
      end
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
