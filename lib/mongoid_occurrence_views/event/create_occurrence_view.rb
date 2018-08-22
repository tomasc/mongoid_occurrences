module MongoidOccurrenceViews
  module Event
    class CreateOccurrencesView
      def initialize(klass)
        @klass = klass
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        CreateView.call(
          name: klass.occurrences_view_name,
          collection: klass.collection.name,
          pipeline: pipeline
        )
      end

      private

      attr_reader :klass

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
