require 'test_helper'

describe MongoidOccurrences::Occurrence do
  let(:occurrence) { build :occurrence }

  it { occurrence.must_respond_to :event }

  it { occurrence.must_respond_to :dtstart }
  it { occurrence.must_respond_to :dtend }

  it { occurrence.must_respond_to :all_day }
  it { occurrence.must_respond_to :all_day? }

  it { occurrence.must_respond_to :updated_at }

  describe 'all_day' do
    let(:occurrence) { build :occurrence, :today, dtstart: DateTime.now.beginning_of_day, dtend: DateTime.now.end_of_day }

    it { occurrence.must_be :all_day }
    it { occurrence.must_be :all_day? }
  end

  describe '#adjust_dates_for_all_day on validate!' do
    let(:occurrence) { build :occurrence, :today, :all_day }

    before { occurrence.validate! }

    it { occurrence.dtstart.must_equal occurrence.dtstart.beginning_of_day }
    it { occurrence.dtend.must_equal occurrence.dtend.end_of_day }
  end
end
