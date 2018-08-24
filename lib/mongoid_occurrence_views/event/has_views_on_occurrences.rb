module MongoidOccurrenceViews
  module Event
    module HasViewsOnOccurrences
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

        def within_expanded_occurrences(&block)
          criteria.with(collection: expanded_occurrences_view_name, &block)
        end

        def within_occurrences(&block)
          criteria.with(collection: occurrences_view_name, &block)
        end
      end
    end
  end
end
