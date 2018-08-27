require 'test_helper'

describe MongoidOccurrenceViews::Event::CreateOccurrencesOrderingView do
  let(:event_view) { subject.new(Event) }
  let(:parent_view) { subject.new(EventParent) }

  describe 'aggregation' do
    let(:today) { DateTime.now.beginning_of_day + 4.hours }

    before do
      @today = create(:event, :today)
      @tomorrow_and_yesterday = create(:event, :tomorrow_and_yesterday)
    end

    it { Event.collection.aggregate(event_view.pipeline).to_a.map { |h| h['_sort_dtstart'] }.must_equal [(today - 1.day).utc, today.utc] }
  end
end
