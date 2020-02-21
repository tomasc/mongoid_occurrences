require 'test_helper'

describe MongoidOccurrences::DailyOccurrence do
  describe '#all_day?' do
    let(:daily_occurrence) { build :daily_occurrence }

    describe 'fields' do
      it { _(daily_occurrence).must_respond_to :ds }
      it { _(daily_occurrence).must_respond_to :dtstart }

      it { _(daily_occurrence).must_respond_to :de }
      it { _(daily_occurrence).must_respond_to :dtend }
    end

    describe 'accessors' do
      it { _(daily_occurrence).must_respond_to :operator }
      it { _(daily_occurrence.operator).must_equal :append }
    end

    describe '#all_day' do
      let(:daily_occurrence) { build :daily_occurrence, dtstart: Time.zone.now.beginning_of_day, dtend: Time.zone.now.end_of_day }

      it { _(daily_occurrence).must_be :all_day }
      it { _(daily_occurrence).must_be :all_day? }
    end
  end
end
