require 'test_helper'

describe MongoidOccurrenceViews::HasOccurrences do
  let(:subject) { ::Event }
  let(:event) { build :event }

  describe 'scopes' do
    it { subject.must_respond_to :occurs_between }
    it { subject.must_respond_to :occurs_from }
    it { subject.must_respond_to :occurs_on }
    it { subject.must_respond_to :occurs_until }
  end

  describe 'relations' do
    it { event.must_respond_to :occurrences }
    it { event.must_respond_to :daily_occurrences }
  end

  describe '#dtstart & #dtend' do
    let(:occurrence_1) { build :occurrence, :today }
    let(:occurrence_2) { build :occurrence, :tomorrow }
    let(:event) { create :event, occurrences: [occurrence_1, occurrence_2] }

    it { event.dtstart.must_equal occurrence_1.dtstart }
    it { event.dtend.must_equal occurrence_2.dtend }
  end

  describe 'daily_occurrences' do
    let(:occurrence_1) { build :occurrence, :today }
    let(:occurrence_2) { build :occurrence, :tomorrow }
    let(:event) { build :event, occurrences: [occurrence_1, occurrence_2] }

    before { event.assign_daily_occurrences! }

    it { event.daily_occurrences.size.must_equal 2 }
  end
end
