require 'test_helper'

describe MongoidOccurrenceViews::DailyOccurrence do
  describe '#all_day?' do
    let(:daily_occurrence) { build :daily_occurrence }

    describe 'fields' do
      it { daily_occurrence.must_respond_to :ds }
      it { daily_occurrence.must_respond_to :dtstart }

      it { daily_occurrence.must_respond_to :de }
      it { daily_occurrence.must_respond_to :dtend }
    end

    describe 'accessors' do
      it { daily_occurrence.must_respond_to :operator }
      it { daily_occurrence.operator.must_equal :append }
    end

    describe '#all_day' do
      let(:daily_occurrence) { build :daily_occurrence, dtstart: Time.now.beginning_of_day, dtend: Time.now.end_of_day }

      it { daily_occurrence.must_be :all_day }
      it { daily_occurrence.must_be :all_day? }
    end
  end
end
