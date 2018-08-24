require 'test_helper'

describe MongoidOccurrenceViews::Event::CreateOccurrencesView do
  let(:event_view) { subject.new(Event) }
  let(:parent_view) { subject.new(EventParent) }

  describe '#pipeline' do
    let(:event_pipeline) do
      [
        { '$addFields': { '_occurrences': '$occurrences' } },
        { '$unwind': '$_occurrences' },
        { '$unwind': '$_occurrences.daily_occurrences' },
        { '$addFields': {
          '_dtstart': '$_occurrences.daily_occurrences.ds',
          '_dtend': '$_occurrences.daily_occurrences.de',
          '_sort_key': '$_occurrences.daily_occurrences.ds'
        } }
      ]
    end

    let(:parent_pipeline) do
      [
        { '$addFields': { '_embedded_events': '$embedded_events' } },
        { '$unwind': '$_embedded_events' },
        { '$unwind': '$_embedded_events.occurrences' },
        { '$unwind': '$_embedded_events.occurrences.daily_occurrences' },
        { '$addFields': {
          '_dtstart': '$_embedded_events.occurrences.daily_occurrences.ds',
          '_dtend': '$_embedded_events.occurrences.daily_occurrences.de',
          '_sort_key': '$_embedded_events.occurrences.daily_occurrences.ds'
        } }
      ]
    end

    it { event_view.pipeline.must_equal event_pipeline }
    it { parent_view.pipeline.must_equal parent_pipeline }
  end

  # TODO: Or not to do?
  # describe '#call' do
  # end
end
