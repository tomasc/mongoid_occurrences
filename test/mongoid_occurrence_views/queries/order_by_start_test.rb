require 'test_helper'

describe MongoidOccurrenceViews::Queries::OrderByStart do
  let(:query_ascending) { subject.criteria(klass, :asc) }
  let(:query_descending) { subject.criteria(klass, :desc) }

  describe 'Ordering Events' do
    let(:klass) { Event }

    before do
      @today = create(:event, :today)
      # @tomorrow = create(:event, :tomorrow)
      @tomorrow_and_yesterday = create(:event, :tomorrow_and_yesterday)
      # @yesterday = create(:event, :yesterday)
      # @last_week = create(:event, :last_week)
      # @next_week = create(:event, :next_week)
    end

    it do
      puts klass.collection.aggregate(MongoidOccurrenceViews::Event::CreateOccurrencesOrderingView.new(Event).pipeline).to_a.map { |h| h['_order_dtstart'] }
      # puts klass.collection.aggregate(MongoidOccurrenceViews::Event::CreateOccurrencesOrderingView.new(Event).pipeline).to_a.map { |h| h['_order_dtend'] }
    end

    # it { klass.order_by_start(:asc).to_a.must_equal [@last_week, @today, @next_week] }
    # it { klass.order_by_start(:desc).to_a.must_equal [@next_week, @today, @last_week] }
    #
    # it { klass.order_by_end(:desc).to_a.must_equal [@last_week, @today, @next_week] }
    # it { klass.order_by_end(:asc).to_a.must_equal [@next_week, @today, @last_week] }
  end

  # describe 'Ordering Parent with Embedded Events' do
  #   let(:klass) { EventParent }
  #
  #   it { klass.order_by_start(:asc).to_a.must_equal [@last_week, @today, @next_week] }
  #   it { klass.order_by_start(:desc).to_a.must_equal [@next_week, @today, @last_week] }
  #
  #   it { klass.order_by_end(:desc).to_a.must_equal [@last_week, @today, @next_week] }
  #   it { klass.order_by_end(:asc).to_a.must_equal [@next_week, @today, @last_week] }
  # end
end
