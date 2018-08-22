module MongoidOccurrenceViews
  module Event
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def embeds_many_occurrences(options = {})
        embeds_many :occurrences, class_name: options.fetch(:class_name)
        accepts_nested_attributes_for :occurrences, allow_destroy: true

        create_occurrence_view
        create_expanded_occurrence_view
      end

      def occurrences_view_name
        [collection.name, 'occurrences_view'].join('__').freeze
      end

      def expanded_occurrences_view_name
        [collection.name, 'expanded_occurrences_view'].join('__').freeze
      end

      def with_expanded_occurrences_view(&block)
        criteria.with(collection: expanded_occurrences_view_name) { block }
      end

      def with_occurrences_view(&block)
        criteria.with(collection: occurrences_view_name) { block }
      end

      private

      def create_occurrence_view
        MongoidOccurrenceViews::CreateView.call(
          occurrences_view_name,
          collection.name,
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
        )
      end

      def create_expanded_occurrence_view
        MongoidOccurrenceViews::CreateView.call(
          expanded_occurrences_view_name,
          collection.name,
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
        )
      end
    end
  end
end
