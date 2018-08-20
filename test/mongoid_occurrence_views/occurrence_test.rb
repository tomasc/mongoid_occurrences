require "test_helper"

module MongoidOccurrenceViews
  describe Occurrence do
    let(:start_date) { Time.parse '20/08/2018 09:00' }
    let(:end_date) { Time.parse '20/08/2018 21:00' }

    subject { DummyOccurrence.new(dtstart: start_date) }

    describe 'fields' do
      it { subject.must_respond_to :dtstart }
      it { subject.must_respond_to :dtend }
      it { subject.must_respond_to :all_day }
      it { subject.must_respond_to :schedule }
    end

    describe '#schedule' do
      let(:ice_cube_schedule) {
        IceCube::Schedule.new(start_date) do |s|
          s.add_recurrence_rule IceCube::Rule.daily(1).count(7)
        end
      }

      subject { DummyOccurrence.new(dtstart: start_date, dtend: end_date, schedule: ice_cube_schedule) }

      describe 'fields' do
        it { subject.must_respond_to :occurrences }
      end

      describe '#occurrences' do
        before { subject.run_callbacks(:validation) }

        it { subject.occurrences.must_be :present? }
        it { subject.occurrences.first.must_equal({ dtstart: start_date.to_time.utc, dtend: end_date.to_time.utc, all_day: false }) }
      end
    end
  end
end
