require 'test_helper'

describe MongoidOccurrences::Occurrence::HasOperators do
  let(:subject) { ::Occurrence }
  let(:occurrence) { build :occurrence }

  describe 'Scopes' do
    it { _(subject).must_respond_to :with_operators }
  end

  describe '#operator' do
    it { _(occurrence).must_respond_to :operator }
    it { _(occurrence.operator).must_equal :append }
  end

  describe ':append' do
    let(:occurrence_1) { build :occurrence, :append, :yesterday }
    let(:occurrence_2) { build :occurrence, :append, :today, schedule: build(:schedule, :daily_for_a_week) }
    let(:event) { build :event, occurrences: [occurrence_1, occurrence_2] }

    before { event.assign_daily_occurrences! }

    it { _(event.daily_occurrences.size).must_equal 8 }
  end

  describe ':replace' do
    let(:dtstart) { Time.zone.now.beginning_of_day + 1.day + 1.hour }
    let(:dtend) { Time.zone.now.beginning_of_day + 1.day + 11.hours }

    let(:occurrence_1) { build :occurrence, :append, :today, schedule: build(:schedule, :daily_for_a_week) }
    let(:occurrence_2) { build :occurrence, :replace, :tomorrow, dtstart: dtstart, dtend: dtend }
    let(:event) { build :event, occurrences: [occurrence_1, occurrence_2] }

    before { event.assign_daily_occurrences! }

    it { _(event.daily_occurrences.size).must_equal 7 }
    it { _(event.daily_occurrences[1].dtstart).must_equal dtstart }
    it { _(event.daily_occurrences[1].dtend).must_equal dtend }
  end

  describe ':remove' do
    let(:occurrence_1) { build :occurrence, :append, :today, schedule: build(:schedule, :daily_for_a_week) }
    let(:occurrence_2) { build :occurrence, :remove, :tomorrow }
    let(:event) { build :event, occurrences: [occurrence_1, occurrence_2] }

    before { event.assign_daily_occurrences! }

    it { _(event.daily_occurrences.size).must_equal 6 }
  end
end
