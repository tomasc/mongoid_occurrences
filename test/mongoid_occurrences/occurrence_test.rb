require 'test_helper'

describe MongoidOccurrences::Occurrence do
  let(:occurrence) { build :occurrence }

  it { _(occurrence).must_respond_to :event }

  it { _(occurrence).must_respond_to :dtstart }
  it { _(occurrence).must_respond_to :dtend }

  it { _(occurrence).must_respond_to :all_day }
  it { _(occurrence).must_respond_to :all_day? }

  it { _(occurrence).must_respond_to :updated_at }

  describe 'all_day' do
    let(:occurrence) { build :occurrence, :today, dtstart: Time.zone.now.beginning_of_day, dtend: Time.zone.now.end_of_day }

    it { _(occurrence).must_be :all_day }
    it { _(occurrence).must_be :all_day? }
  end

  describe '#adjust_dates_for_all_day on validate!' do
    let(:occurrence) { build :occurrence, :today, :all_day }

    before { occurrence.validate! }

    it { _(occurrence.dtstart).must_equal occurrence.dtstart.beginning_of_day }
    it { _(occurrence.dtend).must_equal occurrence.dtend.end_of_day }
  end
end
