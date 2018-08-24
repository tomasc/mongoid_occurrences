require 'test_helper'

describe MongoidOccurrenceViews::CreateExpandedOccurrencesView do
  let(:view) { MongoidOccurrenceViews::CreateExpandedOccurrencesView.new }
  let(:event_pipeline) {
    [
      { '$addFields': { '_occurrences': '$occurrences' } },
      { '$unwind': '$_occurrences' },
      { '$unwind': '$_occurrences.daily_occurrences' },
      { '$addFields': {
        '_dtstart': '$_occurrences.daily_occurrences.ds',
        '_dtend': '$_occurrences.daily_occurrences.de',
        '_sort_key': '$_occurrences.daily_occurrences.ds'
        }
      }
    ]
  }
  let(:owner_pipeline) {
    [
      { '$addFields': { '_events': '$events' } },
      { '$unwind': '$_events' },
      { '$unwind': '$_events.occurrences' },
      { '$unwind': '$_events.occurrences.daily_occurrences' },
      { '$addFields': {
        '_dtstart': '$_events.occurrences.daily_occurrences.ds',
        '_dtend': '$_events.occurrences.daily_occurrences.de',
        '_sort_key': '$_events.occurrences.daily_occurrences.ds'
        }
      }
    ]
  }

  it { MongoidOccurrenceViews::CreateExpandedOccurrencesView.call(DummyEvent).must_equal event_pipeline }
  it { MongoidOccurrenceViews::CreateExpandedOccurrencesView.call(DummyOwner).must_equal owner_pipeline }
end
