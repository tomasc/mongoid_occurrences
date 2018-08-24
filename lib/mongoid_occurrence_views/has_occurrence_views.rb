module MongoidOccurrenceViews
  module HasOccurrenceViews
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def occurrences_view_name
        [collection.name, 'occurrences_view'].join('__').freeze
      end

      def expanded_occurrences_view_name
        [collection.name, 'expanded_occurrences_view'].join('__').freeze
      end

      def with_expanded_occurrences_view(&block)
        criteria.with collection: expanded_occurrences_view_name, &block
      end

      def with_occurrences_view(&block)
        criteria.with collection: occurrences_view_name, &block
      end

      def create_occurrence_views
        MongoidOccurrenceViews::CreateExpandedOccurrencesView.call(self)
      end
    end
  end
end
