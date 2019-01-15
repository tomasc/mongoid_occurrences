require 'test_helper'

describe MongoidOccurrences::HasFieldsFromAggregation do
  let(:subject) { ::Event }
  let(:event) { build :event }

  describe '#dtstart & #dtend' do
    let(:occurrence_1) { build :occurrence, :today }
    let(:occurrence_2) { build :occurrence, :tomorrow }
    let(:event) { build :event, occurrences: [occurrence_1, occurrence_2] }

    before { event.assign_daily_occurrences! }

    it { event.dtstart.must_equal occurrence_1.dtstart }
    it { event.dtend.must_equal occurrence_2.dtend }
  end

  describe '#all_day?' do
    let(:occurrence) { build :occurrence, :today, :all_day }
    let(:event) { build :event, occurrences: [occurrence] }

    before { event.assign_daily_occurrences! }

    it { event.must_be :all_day }
    it { event.must_be :all_day? }
  end
end
