module MongoidOccurrenceViews
  module Event
    class CreateExpandedOccurrencesView
      def initialize(klass)
        @klass = klass
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        CreateView.call(
          name: klass.expanded_occurrences_view_name,
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
            '_sort_key': '$_occurrences.daily_occurrences.ds'
            }
          }
        ]
      end
    end
  end
end
