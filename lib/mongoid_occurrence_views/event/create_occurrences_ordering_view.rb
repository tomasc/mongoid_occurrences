module MongoidOccurrenceViews
  module Event
    class CreateOccurrencesOrderingView
      def initialize(klass)
        @klass = klass
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        CreateMongodbView.call(
          name: klass.occurrences_ordering_view_name,
          collection: klass.collection.name,
          pipeline: pipeline
        )
      end

      def pipeline
        [
          { '$unwind': '$occurrences' },
          { '$unwind': '$occurrences.daily_occurrences' },
          { '$sort': { 'occurrences.daily_occurrences.ds': 1 } },
          { '$addFields': { '_sort_dtstart': '$occurrences.daily_occurrences.ds' } }
          # { '$addFields': {
          #   '_sort_dtstart': {
          #     '$ifNull': [
          #       {
          #         '$min': {
          #           '$filter': {
          #             'input': '$daily_occurrences.ds',
          #             'as': 'dtstart',
          #             'cond': {
          #               '$gte': ['$$dtstart', 'new Date()']
          #             }
          #           }
          #         }
          #       },
          #       "foo"
          #       # { '$max': { '$filter': { 'input': { '$arrayElemAt': ['$occurrences.daily_occurrences.ds', 0] }, 'as': 'dtstart', 'cond': { '$lt': ['$$dtstart', 'new Date()'] } } } }
          #     ]
          #   },
          #   # '_sort_dtend': {
          #   #   '$ifNull': [
          #   #     { '$min': { '$filter': { 'input': { '$arrayElemAt': ['$occurrences.daily_occurrences.de', 0] }, 'as': 'dtend', 'cond': { '$gte': ['$$dtend', 'new Date()'] } } } },
          #   #     { '$max': { '$filter': { 'input': { '$arrayElemAt': ['$occurrences.daily_occurrences.de', 0] }, 'as': 'dtend', 'cond': { '$lt': ['$$dtend', 'new Date()'] } } } }
          #   #     ]
          #   #   }
          #   }
          # }
        ]
      end

      private

      attr_reader :klass
    end
  end
end
