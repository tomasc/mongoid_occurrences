require 'test_helper'

describe MongoidOccurrences::Occurrence::HasSchedule do
  let(:occurrence) { build :occurrence, schedule: build(:schedule, :daily_for_a_week) }

  it { _(occurrence).must_be :recurring? }
  it { _(occurrence).must_respond_to :schedule_dtstart }
  it { _(occurrence).must_respond_to :schedule_dtend }

  it { _(occurrence.schedule_dtstart.to_i).must_equal Time.zone.now.to_i }
  it { _(occurrence.schedule_dtend.to_i).must_equal (Time.zone.now + MongoidOccurrences::Occurrence::HasSchedule::SCHEDULE_DURATION).to_i }

  describe 'nil_schedule' do
    let(:occurrence) { build :occurrence, :today }

    before { occurrence.validate! }

    it { _(occurrence.schedule).must_be_nil }
  end
end
