require 'test_helper'

describe MongoidOccurrenceViews::Occurrence::HasSchedule do
  let(:occurrence) { build :occurrence, schedule: build(:schedule, :daily_for_a_week) }

  it { occurrence.must_be :recurring? }
  it { occurrence.must_respond_to :schedule_dtstart }
  it { occurrence.must_respond_to :schedule_dtend }

  it { occurrence.schedule_dtstart.to_i.must_equal Time.now.to_i }
  it { occurrence.schedule_dtend.to_i.must_equal (Time.now + MongoidOccurrenceViews::Occurrence::HasSchedule::SCHEDULE_DURATION).to_i }

  describe 'nil_schedule' do
    let(:occurrence) { build :occurrence, :today }

    before { occurrence.validate! }

    it { occurrence.schedule.must_be_nil }
  end
end
