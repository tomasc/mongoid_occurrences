require 'test_helper'

describe MongoidOccurrences::Queries::OccursUntil do
  let(:occurrence) { build :occurrence, :today }
  let(:event) { build :event, occurrences: [occurrence] }

  before { event.assign_daily_occurrences! }

  describe 'DateTime' do
    it { event.daily_occurrences.occurs_until(occurrence.dtend).must_be :exists? }
    it { event.daily_occurrences.occurs_until(occurrence.dtend + 1.week).must_be :exists? }
    it { event.daily_occurrences.occurs_until(occurrence.dtend - 1.week).wont_be :exists? }
  end

  describe 'Date' do
    it { event.daily_occurrences.occurs_until(occurrence.dtstart.to_date).must_be :exists? }
    it { event.daily_occurrences.occurs_until(occurrence.dtstart.to_date + 1.week).must_be :exists? }
    it { event.daily_occurrences.occurs_until(occurrence.dtstart.to_date - 1.week).wont_be :exists? }
  end
end
