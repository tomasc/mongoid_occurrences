require 'mongoid'

module MongoidOccurrenceViews
  module Event
    class CreateOccurrencesView
      attr_accessor :klass

      def initialize(klass)
        @klass = klass
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        MongoidOccurrenceViews::CreateView.call(
          name: view_name,
          collection: collection,
          pipeline: pipeline
        )
      end

      private

      def view_name
        klass.occurrences_view_name
      end

      def collection
        klass.collection.name
      end

      def pipeline
        [
          { '$addFields': {
            '_sort_key': {
              '$ifNull': [
                { '$min': { '$filter': { 'input': { '$arrayElemAt': ['$occurrences.daily_occurrences.ds', 0] }, 'as': 'dtstart', 'cond': { '$gte': ['$$dtstart', 'new Date()'] } } } },
                { '$max': { '$filter': { 'input': { '$arrayElemAt': ['$occurrences.daily_occurrences.ds', 0] }, 'as': 'dtstart', 'cond': { '$lt': ['$$dtstart', 'new Date()'] } } } }
                ]
              }
            }
          }
        ]
      end
    end
  end
end
