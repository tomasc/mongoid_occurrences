require 'test_helper'

describe MongoidOccurrenceViews::Event::CreateOccurrencesOrderingView do
  describe '1) earliest dtstart and latest dtend' do
    let(:view) { subject.new(klass) }
    let(:yesterday) { build :occurrence, :yesterday }
    let(:today) { build :occurrence, :today }
    let(:tomorrow) { build :occurrence, :tomorrow }
    let(:last_week) { build :occurrence, :last_week }
    let(:next_week) { build :occurrence, :next_week }
    let(:occurrences) { [tomorrow, last_week, yesterday, next_week].shuffle }

    describe '#pipeline' do
      let(:pipeline) { view.pipeline }
      let(:aggregation) { klass.collection.aggregate(pipeline) }

      describe 'Events' do
        let(:klass) { Event }

        # let(:pipeline) {
        #   [
        #     {
        #       '$addFields': {
        #         '_dtstart': {
        #           '$min': {
        #             '$min': '$occurrences.daily_occurrences.ds'
        #           }
        #         },
        #         '_dtend': {
        #           '$max': {
        #             '$max': '$occurrences.daily_occurrences.de'
        #           }
        #         },
        #       }
        #     }
        #   ]
        # }

        before { create :event, occurrences: [tomorrow, last_week, yesterday, next_week].shuffle }

        let(:doc) { aggregation.to_a.first }
        let(:_dtstart) { DateTime.demongoize(doc['_dtstart']) }
        let(:_dtend) { DateTime.demongoize(doc['_dtend']) }

        it { aggregation.to_a.length.must_equal 1 }
        it { _dtstart.must_equal last_week.dtstart }
        it { _dtend.must_equal next_week.dtend }
      end

      describe 'EventParents' do
        let(:klass) { EventParent }
        let(:event_yesterday) { build :embedded_event, occurrences: [yesterday] }
        let(:event_today) { build :embedded_event, occurrences: [today] }
        let(:event_tomorrow) { build :embedded_event, occurrences: [tomorrow] }
        let(:event_last_week) { build :embedded_event, occurrences: [last_week] }
        let(:event_next_week) { build :embedded_event, occurrences: [next_week] }

        # let(:pipeline) {
        #   [
        #     {
        #       '$addFields': {
        #         '_dtstart': {
        #           '$min': {
        #             '$min': {
        #               '$min': '$embedded_events.occurrences.daily_occurrences.ds'
        #             }
        #           }
        #         },
        #         '_dtend': {
        #           '$max': {
        #             '$max': {
        #               '$max': '$embedded_events.occurrences.daily_occurrences.de'
        #             }
        #           }
        #         }
        #       }
        #     }
        #   ]
        # }

        before {
          create :event_parent, embedded_events: [event_yesterday, event_last_week, event_tomorrow]
        }

        let(:doc) { aggregation.to_a.first }
        let(:_dtstart) { DateTime.demongoize(doc['_dtstart']) }
        let(:_dtend) { DateTime.demongoize(doc['_dtend']) }

        it { aggregation.to_a.length.must_equal 1 }
        it { _dtstart.must_equal last_week.dtstart }
        it { _dtend.must_equal tomorrow.dtend }
      end
    end
  end

  # describe '2) nearest' do
  #   let(:pipeline) {
  #     [
  #       { '$addFields': {
  #         '_key': {
  #             '$filter': {
  #               'input': {
  #                 '$map': {
  #                   'input': '$occurrences.daily_occurrences.ds',
  #                   'as': 'el',
  #                   'in': { '$arrayElemAt': ['$$el', 0] }
  #                 }
  #               },
  #               'as': 'dtstart',
  #               # FIXME: problem is we'd need some way to input current date here
  #               # @see https://jira.mongodb.org/browse/SERVER-23656
  #               'cond': { '$gt': [ '$$dtstart', 'new Date()'] }
  #             }
  #           }
  #
  #           # TODO: below would need to be added – take either first upcoming, and if it does not exist then the last past
  #           # {
  #           # '$ifNull': [
  #           #   { '$min': { '$filter': { 'input': { '$arrayElemAt': ['$occurrences.daily_occurrences.ds', 0] }, 'as': 'ds', 'cond': { '$gte': ['$$ds', 'new Date()'] } } } },
  #           #   { '$max': { '$filter': { 'input': { '$arrayElemAt': ['$occurrences.daily_occurrences.ds', 0] }, 'as': 'ds', 'cond': { '$lt': ['$$ds', 'new Date()'] } } } }
  #           #   ]
  #           # }
  #         }
  #       }
  #     ]
  #   }
  #
  #   let(:yesterday) { build :occurrence, :yesterday }
  #   let(:today) { build :occurrence, :today }
  #   let(:tomorrow) { build :occurrence, :tomorrow }
  #
  #   before { @event = create :event, occurrences: [yesterday, today, tomorrow] }
  #
  #   let(:doc) { Event.collection.aggregate(pipeline).to_a.first }
  #   # let(:_key) { DateTime.demongoize(doc['_key']) }
  #
  #   it { doc['_key'].must_equal today.dtstart }
  # end
end
