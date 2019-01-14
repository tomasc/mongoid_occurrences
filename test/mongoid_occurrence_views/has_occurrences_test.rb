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

  describe 'daily_occurrences' do
    let(:occurrence_1) { build :occurrence, :today }
    let(:occurrence_2) { build :occurrence, :tomorrow }
    let(:event) { build :event, occurrences: [occurrence_1, occurrence_2] }

    before { event.assign_daily_occurrences! }

    it { event.daily_occurrences.size.must_equal 2 }
  end

  describe '#occurrences_cache_key' do
    let(:occurrence_1) { build :occurrence, :today, updated_at: Time.now - 1.day }
    let(:occurrence_2) { build :occurrence, :tomorrow, updated_at: Time.now }
    let(:event) { build :event, occurrences: [occurrence_1, occurrence_2] }

    it { event.occurences_cache_key.must_equal "2-#{occurrence_2.updated_at.to_i}" }

    describe `#previous_occurences_cache_key_changed?` do
      before { event.validate! }

      it { event.must_be :previous_occurences_cache_key_changed? }
    end
  end
end
