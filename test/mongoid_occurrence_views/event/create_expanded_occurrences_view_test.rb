# TODO: add this test

# require 'test_helper'
#
# describe MongoidOccurrenceViews::CreateExpandedOccurrencesView do
#   let(:event_view) { MongoidOccurrenceViews::CreateExpandedOccurrencesView.new(Event) }
#   let(:owner_view) { MongoidOccurrenceViews::CreateExpandedOccurrencesView.new(EventParent) }
#
#   describe '#pipeline' do
#     let(:event_pipeline) do
#       [
#         { '$addFields': { '_occurrences': '$occurrences' } },
#         { '$unwind': '$_occurrences' },
#         { '$unwind': '$_occurrences.daily_occurrences' },
#         { '$addFields': {
#           '_dtstart': '$_occurrences.daily_occurrences.ds',
#           '_dtend': '$_occurrences.daily_occurrences.de',
#           '_sort_key': '$_occurrences.daily_occurrences.ds'
#         } }
#       ]
#     end
#
#     let(:owner_pipeline) do
#       [
#         { '$addFields': { '_events': '$events' } },
#         { '$unwind': '$_events' },
#         { '$unwind': '$_events.occurrences' },
#         { '$unwind': '$_events.occurrences.daily_occurrences' },
#         { '$addFields': {
#           '_dtstart': '$_events.occurrences.daily_occurrences.ds',
#           '_dtend': '$_events.occurrences.daily_occurrences.de',
#           '_sort_key': '$_events.occurrences.daily_occurrences.ds'
#         } }
#       ]
#     end
#
#     it { event_view.pipeline.must_equal event_pipeline }
#     it { owner_view.pipeline.must_equal owner_pipeline }
#   end
# end
