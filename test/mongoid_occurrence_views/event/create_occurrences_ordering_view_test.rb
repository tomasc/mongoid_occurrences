require 'test_helper'

describe MongoidOccurrenceViews::Event::CreateOccurrencesOrderingView do
  let(:event_view) { subject.new(Event) }
  let(:parent_view) { subject.new(EventParent) }

  describe '1) first' do
    let(:pipeline) { event_view.pipeline }
    let(:yesterday) { build :occurrence, :yesterday }
    let(:today) { build :occurrence, :today }
    let(:tomorrow) { build :occurrence, :tomorrow }

    before { create :event, occurrences: [tomorrow, today, yesterday] }

    let(:doc) { Event.collection.aggregate(pipeline).to_a.first }
    let(:_order_dtstart) { DateTime.demongoize(doc['_order_dtstart']) }
    let(:_order_dtend) { DateTime.demongoize(doc['_order_dtend']) }

    it { pipeline.must_equal event_view.pipeline }
    it { _order_dtstart.must_equal yesterday.dtstart }
    it { _order_dtend.must_equal tomorrow.dtend }
  end

  # describe '2) nearest' do
  #   let(:pipeline) {
  #     [
  #       { '$addFields': {
  #         '_order_key': {
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
  #   # let(:_order_key) { DateTime.demongoize(doc['_order_key']) }
  #
  #   it { doc['_order_key'].must_equal today.dtstart }
  # end
end
