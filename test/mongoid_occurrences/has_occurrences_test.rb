require 'test_helper'

describe MongoidOccurrences::HasOccurrences do
  let(:subject) { ::Event }
  let(:event) { build :event }

  describe 'scopes' do
    it { _(subject).must_respond_to :occurs_between }
    it { _(subject).must_respond_to :occurs_from }
    it { _(subject).must_respond_to :occurs_on }
    it { _(subject).must_respond_to :occurs_until }
  end

  describe 'relations' do
    it { _(event).must_respond_to :occurrences }
    it { _(event).must_respond_to :daily_occurrences }
  end

  describe 'daily_occurrences' do
    let(:occurrence_1) { build :occurrence, :today }
    let(:occurrence_2) { build :occurrence, :tomorrow }
    let(:event) { build :event, occurrences: [occurrence_1, occurrence_2] }

    before { event.assign_daily_occurrences! }

    it { event.daily_occurrences.size.must_equal 2 }

    it 'wipes the daily occurrences' do
      event = create(:event, :occurring_today_and_tomorrow)

      _(event.daily_occurrences.size).must_equal 2

      event.occurrences = nil
      event.assign_daily_occurrences!

      _(event.daily_occurrences.size).must_equal 0
    end
  end

  describe '#occurrences_cache_key' do
    let(:occurrence_1) { build :occurrence, :today, updated_at: Time.zone.now - 1.day }
    let(:occurrence_2) { build :occurrence, :tomorrow, updated_at: Time.zone.now }
    let(:event) { build :event, occurrences: [occurrence_1, occurrence_2] }

    it { _(event.occurrences_cache_key).must_equal "2-#{occurrence_2.updated_at.to_i}" }

    describe '#previous_occurrences_cache_key_changed?' do
      before { event.validate! }

      it { _(event).must_be :_previous_occurrences_cache_key_changed? }
    end
  end
end
