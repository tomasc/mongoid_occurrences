require 'test_helper'

describe MongoidOccurrences::Queries::OccursBetween do
  let(:occurrence) { build :occurrence, :today_until_tomorrow }
  let(:event) { build :event, occurrences: [occurrence] }

  before { event.assign_daily_occurrences! }

  describe 'DateTime' do
    it { event.daily_occurrences.occurs_between(occurrence.dtstart, occurrence.dtend).must_be :exists? }
    it { event.daily_occurrences.occurs_between(occurrence.dtstart + 1.hour, occurrence.dtend - 1.hour).must_be :exists? }
    it { event.daily_occurrences.occurs_between(occurrence.dtstart - 1.hour, occurrence.dtend + 1.hour).must_be :exists? }
    it { event.daily_occurrences.occurs_between(occurrence.dtstart + 10.days, occurrence.dtend + 10.days).wont_be :exists? }
  end

  describe 'Date' do
    it { event.daily_occurrences.occurs_between(occurrence.dtstart.to_date, occurrence.dtend.to_date).must_be :exists? }
    it { event.daily_occurrences.occurs_between(occurrence.dtstart.to_date - 1.day, occurrence.dtend.to_date + 1.day).must_be :exists? }
    it { event.daily_occurrences.occurs_between(occurrence.dtstart.to_date + 10.days, occurrence.dtend.to_date + 10.days).wont_be :exists? }
  end
end
