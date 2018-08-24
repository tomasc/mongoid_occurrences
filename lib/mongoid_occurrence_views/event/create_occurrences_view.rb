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
        CreateMongoidView.call(
          name: klass.occurrences_view_name,
          collection: klass.collection.name,
          pipeline: pipeline
        )
      end

      private

      attr_reader :klass

      def pipeline
        [
          { '$addFields': { '_occurrences': '$occurrences' } },
          { '$unwind': '$_occurrences' },
          { '$unwind': '$_occurrences.daily_occurrences' },
          { '$addFields': {
            '_dtstart': '$_occurrences.daily_occurrences.ds',
            '_dtend': '$_occurrences.daily_occurrences.de',
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
