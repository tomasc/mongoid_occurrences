require "test_helper"

describe MongoidOccurrenceViews::Event do
  let(:event) { ::Event.new }

  it { event.must_respond_to :occurrences }
  it { event.class.occurrences_view_name.must_equal 'events__occurrences_view' }
  it { event.class.expanded_occurrences_view_name.must_equal 'events__expanded_occurrences_view' }

  describe 'views' do
    let(:collection_names) { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten }

    it { collection_names.must_include event.class.occurrences_view_name }
    it { collection_names.must_include event.class.expanded_occurrences_view_name }
  end
end
