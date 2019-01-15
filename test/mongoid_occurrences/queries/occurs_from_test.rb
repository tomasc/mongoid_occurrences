require 'test_helper'

describe MongoidOccurrences::Queries::OccursFrom do
  let(:occurrence) { build :occurrence, :today }
  let(:event) { build :event, occurrences: [occurrence] }

  before { event.assign_daily_occurrences! }

  describe 'DateTime' do
    it { event.daily_occurrences.occurs_from(occurrence.dtstart).must_be :exists? }
    it { event.daily_occurrences.occurs_from(occurrence.dtstart - 1.week).must_be :exists? }
    it { event.daily_occurrences.occurs_from(occurrence.dtstart + 1.week).wont_be :exists? }
  end

  describe 'Date' do
    it { event.daily_occurrences.occurs_from(occurrence.dtstart.to_date).must_be :exists? }
    it { event.daily_occurrences.occurs_from(occurrence.dtstart.to_date - 1.week).must_be :exists? }
    it { event.daily_occurrences.occurs_from(occurrence.dtstart.to_date + 1.week).wont_be :exists? }
  end
end
