require "test_helper"

describe MongoidOccurrenceViews::Event::HasViewsOnOccurrences do
  let(:event_parent) { ::EventParent.new }

  it { event_parent.class.occurrences_view_name.must_equal 'event_parents__occurrences_view' }
  it { event_parent.class.expanded_occurrences_view_name.must_equal 'event_parents__expanded_occurrences_view' }

  describe 'views' do
    let(:collection_names) { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten }

    it { collection_names.must_include event_parent.class.occurrences_view_name }
    it { collection_names.must_include event_parent.class.expanded_occurrences_view_name }
  end
end
