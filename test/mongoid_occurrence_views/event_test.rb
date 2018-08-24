require "test_helper"

describe MongoidOccurrenceViews::Event do
  let(:event) { ::Event.new }

  describe 'relations' do
    it { event.must_respond_to :occurrences }
  end

  describe '.occurrences_view_name' do
    it { event.class.occurrences_view_name.must_equal 'events__occurrences_view' }
  end

  describe '.expanded_occurrences_view_name' do
    it { event.class.expanded_occurrences_view_name.must_equal 'events__expanded_occurrences_view' }
  end

  describe 'views' do
    let(:collection_names) { Mongoid.clients.map{ |name, _| Mongoid.client(name).collections.map(&:name) }.flatten }

    it { collection_names.must_include event.class.occurrences_view_name }
    it { collection_names.must_include event.class.expanded_occurrences_view_name }
  end
end
