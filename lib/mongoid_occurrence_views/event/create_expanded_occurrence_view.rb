module MongoidOccurrenceViews
  module Event
    class CreateExpandedOccurrencesView
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
        klass.expanded_occurrences_view_name
      end

      def collection
        klass.collection.name
      end

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
