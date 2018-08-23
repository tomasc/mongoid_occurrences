require "test_helper"

describe "Embedding of Event" do
  let(:start_date) { DateTime.now.beginning_of_day + 4.hours }
  let(:end_date) { start_date + 2.hours }
  let(:occurrence) { DummyOccurrence.new(dtstart: start_date, dtend: end_date, all_day: false) }
  let(:event) { DummyEvent.new(occurrences: [occurrence])  }
  let(:owner) { DummyOwner.new(events: [event]) }

  before { owner.save! }

  describe 'expanded' do
    it { owner.class.for_date_time_range(start_date, end_date).count.must_equal 0 }
    it { owner.class.for_date_time_range(start_date, end_date).to_a.wont_include owner }
    it { with_view { owner.class.for_date_time_range(start_date, end_date).count.must_equal 1 } }
    it { with_view { owner.class.for_date_time_range(start_date, end_date).to_a.must_include owner } }
  end

  private

  def with_view(&block)
    DummyOwner.with_expanded_occurrences_view(&block)
  end
end
